import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:saver_gallery/saver_gallery.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:share_plus/share_plus.dart';

enum Status { none, loading, complete }

class ImageController extends GetxController {
  var imageList = <String>[].obs;
  var status = Status.none.obs;
  var url = ''.obs;
  final textC = TextEditingController();

  void searchAiImage() async {
    if (textC.text.isEmpty) return;

    status.value = Status.loading;
    imageList.clear();
    url.value = '';

    try {
      final images = await APIs.searchAiImages(textC.text);

      if (images.isNotEmpty) {
        imageList.addAll(images);
        url.value = images.first;
        status.value = Status.complete;
      } else {
        status.value = Status.none;
      }
    } catch (e) {
      status.value = Status.none;
      Get.snackbar("Error", "Failed to load images: $e",
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2));
    }
  }

  Future<void> _saveImageToGallery() async {
    if (url.value.isEmpty) {
      Get.snackbar("Error", "No image URL available to download.",
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2));
      return;
    }

    bool isGranted;

    if (Platform.isAndroid) {
      final deviceInfoPlugin = DeviceInfoPlugin();
      final deviceInfo = await deviceInfoPlugin.androidInfo;
      final sdkInt = deviceInfo.version.sdkInt;

      if (sdkInt >= 33) {
        isGranted = await Permission.photos.request().isGranted;
      } else {
        isGranted = await Permission.storage.request().isGranted;
      }
    } else {
      isGranted = await Permission.photosAddOnly.request().isGranted;
    }

    if (isGranted) {
      try {
        var response = await Dio().get(
          url.value,
          options: Options(responseType: ResponseType.bytes),
        );

        final result = await SaverGallery.saveImage(
          Uint8List.fromList(response.data),
          quality: 60,
          name: "downloaded_image",
          androidRelativePath: "Pictures/appName",
          androidExistNotSave: false,
        );

        debugPrint(result.toString());
        Get.snackbar("Success", "Image saved to gallery!",
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 2));
      } catch (e) {
        Get.snackbar("Error", "Failed to save image: $e",
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 2));
      }
    } else {
      Get.snackbar(
          "Permission Denied", "Unable to save image without permission.",
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2));
    }
  }

  Future<void> shareImage() async {
    if (url.value.isEmpty) {
      Get.snackbar("Error", "No image URL available to share.",
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2));
      return;
    }

    try {
      var response = await Dio().get(
        url.value,
        options: Options(responseType: ResponseType.bytes),
      );

      final directory = Directory.systemTemp;
      final file = await File('${directory.path}/shared_image.jpg')
          .writeAsBytes(response.data);

      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Check out this image!',
      );
    } catch (e) {
      Get.snackbar("Error", "Failed to share image: $e",
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2));
    }
  }
}

class APIs {
  static Future<List<String>> searchAiImages(String prompt) async {
    try {
      final res =
          await get(Uri.parse('https://lexica.art/api/v1/search?q=$prompt'));
      final data = jsonDecode(res.body);
      return List.from(data['images']).map((e) => e['src'].toString()).toList();
    } catch (e) {
      debugPrint('searchAiImages Error: $e');
      return [];
    }
  }
}

class ImageFeature extends StatefulWidget {
  const ImageFeature({super.key});

  @override
  State<ImageFeature> createState() => _ImageFeatureState();
}

class _ImageFeatureState extends State<ImageFeature> {
  final _c = ImageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lumi Image Creator'),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        children: [
          TextFormField(
            controller: _c.textC,
            minLines: 1,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: "Type your image prompt here...",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16.0),
          Obx(() => Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Container(
                  height: 300.0,
                  alignment: Alignment.center,
                  child: _displayAiImage(),
                ),
              )),
          Obx(() => _c.imageList.isNotEmpty
              ? SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: _c.imageList.map((e) {
                      return GestureDetector(
                        onTap: () {
                          _c.url.value = e;
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl: e,
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                )
              : const SizedBox()),
          Padding(
            padding: const EdgeInsets.only(top: 80),
            child: ElevatedButton.icon(
              onPressed: _c.searchAiImage,
              icon: const Icon(Icons.create, color: Colors.white),
              label:
                  const Text('Create', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _displayAiImage() {
    switch (_c.status.value) {
      case Status.none:
        return Lottie.asset(
          'assets/lottie/aid.json',
          width: 250,
          height: 250,
        );
      case Status.loading:
        return Lottie.asset(
          'assets/lottie/jn.json',
          width: 150,
          height: 150,
        );
      case Status.complete:
        if (_c.url.value.isEmpty) {
          return const Text('No image available');
        }
        return Stack(
          alignment: Alignment.bottomRight,
          children: [
            CachedNetworkImage(
              imageUrl: _c.url.value,
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FloatingActionButton(
                    mini: true,
                    onPressed: _c._saveImageToGallery,
                    child: const Icon(Icons.download),
                  ),
                  const SizedBox(width: 8),
                  FloatingActionButton(
                    mini: true,
                    onPressed: _c.shareImage,
                    child: const Icon(Icons.share),
                  ),
                ],
              ),
            ),
          ],
        );
      default:
        return const SizedBox();
    }
  }
}
