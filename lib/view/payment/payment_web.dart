import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:oprs/constant_values.dart';
import 'package:oprs/utils/snack_bar_message.dart';

class WebViewMainPage extends StatefulWidget {
  final String checkOutUrl;
  const WebViewMainPage({super.key, required this.checkOutUrl});
  @override
  State<WebViewMainPage> createState() => _WebViewMainPageState();
}

class _WebViewMainPageState extends State<WebViewMainPage> {
  InAppWebViewController? webViewController;
  int loadingPercentage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Page'),
        centerTitle: true,
         backgroundColor: MyColors.mainThemeDarkColor,
        foregroundColor:MyColors.mainThemeLightColor,
        actions: [
          IconButton(
              onPressed: () async {
                if (webViewController != null && await webViewController!.canGoBack()) {
                  await webViewController!.goBack();
                } else {
                  SnackBarMessage.make(context, "No Back History Found");
                }
              },
              icon: const Icon(Icons.arrow_back)),
          IconButton(
              onPressed: () async {
                if (webViewController != null && await webViewController!.canGoForward()) {
                  await webViewController!.goForward();
                } else {
                  SnackBarMessage.make(context, "No Forward History Found");
                }
              },
              icon: const Icon(Icons.arrow_forward)),
          IconButton(
              onPressed: () {
                webViewController?.reload();
              },
              icon: const Icon(Icons.refresh_rounded))
        ],
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(url: WebUri.uri(Uri.parse(widget.checkOutUrl))),
            onWebViewCreated: (controller) { webViewController = controller; },
            onLoadStart: (controller, url) {
              setState(() { loadingPercentage = 0; });
            },
            onLoadStop: (controller, url) async {
              setState(() { loadingPercentage = 100; });
            },
            onProgressChanged: (controller, progress) {
              setState(() { loadingPercentage = progress; });
            },
            onLoadError: (controller, url, code, message) {
              setState(() { loadingPercentage = 100; });
            },
            onUpdateVisitedHistory: (InAppWebViewController controller, Uri? uri, androidIsReload) async {
              // if (uri != null) {
              //   if (uri.toString().contains('https://chapa.co') ||
              //       uri.toString().contains('checkout/test-payment-receipt/')) {
              //     SnackBarMessage.make(context, 'Payment Successful');
              //   } else {
              //     SnackBarMessage.make(context, 'Payment failed!');
              //   }
              // }
            },
          ),
          if (loadingPercentage < 100)
            Center(
              child: CircularProgressIndicator(
                value: loadingPercentage / 100.0,
              ),
            ),
        ],
      ),
    );
  }
}