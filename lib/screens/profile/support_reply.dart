// ignore_for_file: unnecessary_const
import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:play_pointz/Api/Api.dart';
import 'package:play_pointz/constants/app_colors.dart';
import 'package:play_pointz/constants/default_router.dart';
import 'package:play_pointz/models/profile/support_reply.dart';
import 'package:play_pointz/screens/profile/support.dart';
import 'package:play_pointz/widgets/common/toast.dart';
import 'package:play_pointz/widgets/login/login_button_set.dart';

import 'package:url_launcher/url_launcher.dart';

class SupportReply extends StatefulWidget {
  final String id;
  final String pId;
  const SupportReply({Key key, this.id, this.pId}) : super(key: key);

  @override
  State<SupportReply> createState() => _SupportReplyState();
}

class _SupportReplyState extends State<SupportReply> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<BodyOfSupportReply> supportRep = [];
  bool formvalidated = false;
  bool saveBtnLoading = false;
  var bytes;
  String base64Image;

  bool loadingdata = true;

  getReply() async {
    setState(() {
      loadingdata = true;
    });
    var result = await Api().getSupportReply(
        id: widget.id, pId: widget.pId == "" ? null : widget.pId);
    if (result.done != null) {
      if (result.done) {
        supportRep = result.body;
        setState(() {
          loadingdata = false;
        });
      } else {
        setState(() {
          loadingdata = false;
        });
      }
    } else {
      setState(() {
        loadingdata = false;
      });
      messageToastRed(result.message);
    }
  }

  @override
  void initState() {
    getReply();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text("Support Message"),
        backgroundColor: Colors.white,
      ),
      body: Container(
        child: loadingdata
            ? Center(
                child: SizedBox(
                  height: 60.h,
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: FittedBox(
                    child: Image.asset(
                      "assets/bg/loading-gif.gif",
                      fit: BoxFit.cover,
                      // repeat: false,
                    ),
                  ),
                ),
              )
            : supportRep != null
                ? SingleChildScrollView(
                    reverse: true,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          supportRep != null
                              ? supportRep.isNotEmpty
                                  ? Column(
                                      children: [
                                        for (int i = 0;
                                            i < supportRep.length;
                                            i++)
                                          SupportCard(
                                            supportReply: supportRep[i],
                                            size: size,
                                            index: i,
                                            color: i == supportRep.length - 1
                                                ? Colors.white
                                                : Colors.grey[100],
                                            last: i == supportRep.length - 1,
                                          )
                                      ],
                                    )
                                  : Container()
                              : Container(),
                          saveBtnLoading
                              ? Container(
                                  padding: EdgeInsets.only(top: 24, bottom: 24),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: AppColors.PRIMARY_COLOR,
                                    ),
                                  ),
                                )
                              : Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 20),
                                  width: size.width,
                                  padding: EdgeInsets.symmetric(vertical: 0),
                                  child: loginBtnClr(
                                      loading: saveBtnLoading,
                                      context: context,
                                      size: size,
                                      title: 'Support Option',
                                      route: () {
                                        DefaultRouter.defaultRouter(
                                            SupportPage(
                                              suportId: widget.id,
                                              subject: supportRep.last.subject,
                                            ),
                                            context);
                                      }),
                                ),
                        ],
                      ),
                    ),
                  )
                : Center(
                    child: Text('No support reply Found'),
                  ),
      ),
    );
  }
}

class PDFScreen extends StatefulWidget {
  final String path;
  final String url;
  final String subject;
  final Callback callBack;

  PDFScreen(
      {Key key,
      this.path,
      this.url,
      this.subject = "Support Attachment",
      this.callBack})
      : super(key: key);

  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> with WidgetsBindingObserver {
  bool downloading = false;
  bool downloaded = false;

  Future<void> pdfDownload(String fileurl) async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      //add more permission to request here.
    ].request();

    if (statuses[Permission.storage].isGranted) {
      setState(() {
        downloading = true;
      });
      var dir = await DownloadsPathProvider.downloadsDirectory;
      if (dir != null) {
        String savename = "playPointzSupport.pdf";
        String savePath = dir.path + "/$savename";
        //output:  /storage/emulated/0/Download/banner.png

        try {
          await Dio().download(fileurl, savePath,
              onReceiveProgress: (received, total) {
            if (total != -1) {
              //you can build progressbar feature too
            }
          });
          messageToastGreen('File is saved to download folder.');
          setState(() {
            downloaded = true;
            downloading = false;
          });
        } on DioError {
          setState(() {
            downloaded = false;
            downloading = false;
          });
        }
      }
    } else {}
  }

  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();
  int pages = 0;
  int currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(widget.subject),
        centerTitle: true,
      ),
      backgroundColor: Colors.red,
      body: Stack(
        children: <Widget>[
          PDFView(
            filePath: widget.path,
            enableSwipe: true,
            swipeHorizontal: false,
            autoSpacing: false,
            pageFling: true,
            pageSnap: true,
            defaultPage: currentPage,
            fitPolicy: FitPolicy.BOTH,
            preventLinkNavigation:
                false, // if set to true the link is handled in flutter
            onRender: (_pages) {
              setState(() {
                pages = _pages;
                isReady = true;
              });
              widget.callBack();
            },
            onError: (error) {
              setState(() {
                errorMessage = error.toString();
              });
            },
            onPageError: (page, error) {
              setState(() {
                errorMessage = '$page: ${error.toString()}';
              });
            },
            onViewCreated: (PDFViewController pdfViewController) {
              _controller.complete(pdfViewController);
            },
            onLinkHandler: (String uri) {},
            onPageChanged: (int page, int total) {
              setState(() {
                currentPage = page;
              });
            },
          ),
          errorMessage.isEmpty
              ? !isReady
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container()
              : Center(
                  child: Text(errorMessage),
                )
        ],
      ),
      floatingActionButton: FutureBuilder<PDFViewController>(
        future: _controller.future,
        builder: (context, AsyncSnapshot<PDFViewController> snapshot) {
          if (snapshot.hasData) {
            return FloatingActionButton.extended(
              shape: CircleBorder(),
              label: Container(
                child: downloading
                    ? SpinKitRing(
                        color: Colors.white,
                        size: 20.0,
                        lineWidth: 3,
                      )
                    : downloaded
                        ? Icon(
                            Icons.download_done,
                            color: Colors.white,
                          )
                        : Icon(
                            Icons.download,
                            color: Colors.white,
                          ),
              ),
              onPressed: () async {
                downloading
                    ? null
                    : downloaded
                        ? null
                        : pdfDownload(widget.url);
              },
            );
          }

          return Container();
        },
      ),
    );
  }
}

class SupportCard extends StatefulWidget {
  BodyOfSupportReply supportReply;
  final Size size;
  final int index;
  final Color color;
  bool last;
  // bool downloaded;

  SupportCard({
    Key key,
    this.supportReply,
    this.size,
    this.index,
    this.color,
    this.last = false,
    // this.downloaded = false
  }) : super(key: key);

  @override
  State<SupportCard> createState() => _SupportCardState();
}

class _SupportCardState extends State<SupportCard> {
  String _mimeType = "";

  bool loadingdata = true;
  String loadingPdf = '';
  bool downloading = false;
  bool downloaded = false;

  Future<void> _downloadImage(
    String url, {
    AndroidDestinationType destination,
    bool whenError = false,
    String outputMimeType,
  }) async {
    String mimeType;
    try {
      String imageId;

      if (whenError) {
        imageId = await ImageDownloader.downloadImage(url,
                outputMimeType: outputMimeType)
            .catchError((error) {
          if (error is PlatformException) {
            if (error.code == "404") {
            } else if (error.code == "unsupported_file") {}
            setState(() {});
          }
        }).timeout(Duration(seconds: 10), onTimeout: () {
          return;
        });
      } else {
        if (destination == null) {
          imageId = await ImageDownloader.downloadImage(
            url,
            outputMimeType: outputMimeType,
          );
        } else {
          imageId = await ImageDownloader.downloadImage(
            url,
            destination: destination,
            outputMimeType: outputMimeType,
          );
        }
      }

      if (imageId == null) {
        return;
      }

      mimeType = await ImageDownloader.findMimeType(imageId);
    } on PlatformException {
      setState(() {});
      return;
    }

    if (!mounted) return;

    setState(() {
      _mimeType = 'mimeType: $mimeType';

      if (!_mimeType.contains("video")) {}
      return;
    });
  }

  Future<File> createFileOfPdfUrl(String _url) async {
    Completer<File> completer = Completer();
    try {
      var url = _url;

      final filename = url.substring(url.lastIndexOf("/") + 1);
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/$filename");

      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }

  loadPdf(String url, String support, String pdfCode) {
    try {
      if (loadingPdf == '') {
        setState(() {
          loadingPdf = pdfCode;
        });
        createFileOfPdfUrl(url).then((f) {
          // setState(() {
          var remotePDFpath = f.path;
          if (remotePDFpath.isNotEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PDFScreen(
                  path: remotePDFpath,
                  url: url,
                  subject: support,
                  callBack: () {
                    setState(() {
                      loadingPdf = '';
                    });
                  },
                ),
              ),
            );
          }
        });
      } else {
        messageToastGreen('Please wait');
      }
    } catch (e) {
      setState(() {
        loadingPdf = '';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    ImageDownloader.callback(onProgressUpdate: (String imageId, int progress) {
      setState(() {
        downloading = true;
      });
      if (progress > 99) {
        try {
          var oneSec = Duration(seconds: 1);
          Timer.periodic(
              oneSec,
              (Timer t) => setState(() {
                    downloading = false;
                    downloaded = true;
                  }));
        } catch (e) {
          setState(() {
            downloading = false;
            downloaded = true;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: widget.color,
          border: Border(
            bottom: BorderSide(width: 3.0, color: Colors.white),
          )),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 32.sp,
                child: Stack(children: []),
                backgroundImage: widget.supportReply.startedBy == "Player"
                    ? NetworkImage(
                        widget.supportReply.playerImage ??
                            "https://st3.depositphotos.com/4111759/13425/v/600/depositphotos_134255710-stock-illustration-avatar-vector-male-profile-gray.jpg",
                      )
                    : AssetImage("assets/logos/Playpointz_icon.png"),
              ),
              SizedBox(
                width: 12,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat.yMMMEd().format(
                            DateTime.parse(widget.supportReply.dateCreated)) +
                        ' at ' +
                        DateFormat.jm().format(
                            DateTime.parse(widget.supportReply.dateCreated)),
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    width: widget.size.width - 110,
                    child: Text(
                      widget.supportReply.subject,
                      style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                  )
                ],
              ),
            ],
          ),
          SizedBox(
            height: widget.supportReply.comment != null ? 16 : 0,
          ),
          widget.supportReply.comment != null
              ? Html(
                  data: widget.supportReply.comment,
                  onLinkTap: (url, context, attributes, element) async {
                    if (await canLaunch(url)) {
                      await launch(
                        url,
                      );
                    } else {
                      // throw 'Could not launch $url';
                      messageToastRed('Could not launch $url');
                    }
                  },
                )
              : Container(),
          SizedBox(
            height: widget.supportReply.imageUrl != null ? 16 : 0,
          ),
          widget.supportReply.imageUrl != null
              ? Column(
                  children: [
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        RichText(
                          textAlign: TextAlign.start,
                          text: TextSpan(
                            style: TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                  text: ' One Attachment  ',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 8,
                        ),
                        RichText(
                          text: TextSpan(
                            style: TextStyle(color: Colors.black),
                            children: [
                              WidgetSpan(
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 3.0),
                                  child: Transform.rotate(
                                    angle: 45 * pi / 180,
                                    child: Icon(
                                      Icons.attach_file,
                                      size: 24.sp,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        loadingPdf != 'pdf${widget.index.toString()}'
                            ? InkWell(
                                onTap: () {
                                  widget.supportReply.imageUrl.contains('pdf')
                                      ? loadPdf(
                                          widget.supportReply.imageUrl,
                                          widget.supportReply.subject +
                                              ' - ${(widget.index + 1).toString()}',
                                          'pdf${widget.index.toString()}')
                                      : showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            content: Stack(
                                              alignment: Alignment.center,
                                              children: <Widget>[
                                                FadeInImage.assetNetwork(
                                                  placeholder:
                                                      "assets/bg/loading_2.gif",
                                                  image: widget
                                                      .supportReply.imageUrl,
                                                  // width: MediaQuery.of(context)
                                                  //         .size
                                                  //         .width /
                                                  //     3,
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                },
                                child: Text(' Attachment 01 ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.blue,
                                        fontSize: 16)),
                              )
                            : SizedBox(
                                height: 20,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(' Loading  '),
                                    Container(
                                      margin: EdgeInsets.only(top: 7),
                                      child: SpinKitThreeBounce(
                                        color: Colors.black,
                                        size: 8,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                        Spacer(),
                        widget.supportReply.imageUrl.contains('pdf')
                            ? Container()
                            : widget.last
                                ? InkWell(
                                    onTap: () {
                                      _downloadImage(
                                          widget.supportReply.imageUrl,
                                          outputMimeType: "image/jpeg");
                                    },
                                    child: !downloading
                                        ? downloaded
                                            ? Icon(
                                                Icons.download_done,
                                                color: AppColors.PRIMARY_COLOR,
                                              )
                                            : Icon(
                                                Icons.download,
                                                color: AppColors.PRIMARY_COLOR,
                                              )
                                        : SpinKitRing(
                                            color: AppColors.PRIMARY_COLOR,
                                            size: 20.0,
                                            lineWidth: 3,
                                          ))
                                : Container(),
                      ],
                    ),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }
}
