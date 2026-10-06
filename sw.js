// Service worker minimal : requis pour l'installation, ne met rien en cache.
self.addEventListener("install", function () { self.skipWaiting(); });
self.addEventListener("activate", function (e) { e.waitUntil(self.clients.claim()); });
self.addEventListener("fetch", function () { /* réseau normal, rien d'intercepté */ });
