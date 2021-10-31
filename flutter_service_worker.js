'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "version.json": "0aa70bd768000a56e03ac7eabd78825e",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"assets/fonts/MaterialIcons-Regular.otf": "4e6447691c9509f7acdbf8a931a85ca1",
"assets/NOTICES": "60cf12eba987df7ac126aa04c543a2e9",
"assets/assets/images/catAngry3.png": "cbea996fbf8d282c599e0401bcde69bc",
"assets/assets/images/shot1.png": "1a54be0296aa7f98d6d4d959a89906be",
"assets/assets/images/witchshooting5.png": "09999991e293680d35f6c337e18ccce2",
"assets/assets/images/catAngry7.png": "cb9f712ea98432d290e97ff887293e3f",
"assets/assets/images/cat2.png": "7c4b59cb8e6059832049cdbf0bcc5f2b",
"assets/assets/images/witchshooting4.png": "3ad52721503844d4ad9ac1fc9d9a7359",
"assets/assets/images/cat5.png": "bab675bd4729f17e3ff7406bd655f713",
"assets/assets/images/cat4.png": "681eae641166d90453b5ca3f4a46551e",
"assets/assets/images/bg.png": "20494b6379c097e56c4e0d622a15ef62",
"assets/assets/images/cat3.png": "9443b7a26e6da3fa21caa2a75a4b2b93",
"assets/assets/images/zombie3.png": "2997c3b6939c78152679363b77b24daf",
"assets/assets/images/catAngry2.png": "8bf9a4b575862b2ceba04478c69f6d55",
"assets/assets/images/ATTRIBUTION": "7aea979b0707ebdeb510fff4709555d6",
"assets/assets/images/shot2.png": "0285f80b58a3f9b0af9e1a0e478970f1",
"assets/assets/images/zombie1.png": "3848b630b5415008b5ca547c1654a070",
"assets/assets/images/catAngry5.png": "2d173d93f7c803b3e25b385700170545",
"assets/assets/images/witchshooting2.png": "cf51773df98210be2a337bd918899329",
"assets/assets/images/platform1.png": "51d32f1f8a61209a57d666c4f5aa6501",
"assets/assets/images/catAngry6.png": "66a7596c63735f1a41a5658ee3bda2bd",
"assets/assets/images/catAngry4.png": "ab0b10f046e56e1503b2f9cb356e5469",
"assets/assets/images/shot3.png": "b453ef089bf0eac0246cad3a9c52e239",
"assets/assets/images/witchshooting1.png": "d4d32ea2eaef0fa949f767c4110d764c",
"assets/assets/images/witch.png": "7d0f87d4500da9789f5eab1a734906a9",
"assets/assets/images/bg.jpg": "9e4cb19e961d53acb2a06e860b51691f",
"assets/assets/images/zombie2.png": "b155f7e63698359bf8d35869c8a093ca",
"assets/assets/images/witchshooting3.png": "0edcc5a74e333b41335f58d8ed9dcf2f",
"assets/assets/images/cat1.png": "3e065f06b5089b85af361bf980dbdf43",
"assets/assets/images/catAngry1.png": "69f128f1771e66daa3a9ab19443d7d88",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/AssetManifest.json": "1edbc9099c6f80d0aff3cff5fa33a65e",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "6d342eb68f170c97609e9da345464e5e",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"main.dart.js": "5376cfd7af92431224791cdad77be6cc",
"manifest.json": "af5b7fcd5098b3a502fcf7f406949dc2",
"index.html": "d9e5de91ffa6ef9f30c09397be13ba86",
"/": "d9e5de91ffa6ef9f30c09397be13ba86"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "/",
"main.dart.js",
"index.html",
"assets/NOTICES",
"assets/AssetManifest.json",
"assets/FontManifest.json"];
// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});

// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});

// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache.
        return response || fetch(event.request).then((response) => {
          cache.put(event.request, response.clone());
          return response;
        });
      })
    })
  );
});

self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});

// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}

// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
