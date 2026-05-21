// arkenfox user.js v140 (adapted)
// https://github.com/arkenfox/user.js

/* START: internal custom pref to test for syntax errors ***/
user_pref("_user.js.parrot", "START: Oh yes, the Norwegian Blue... what's wrong with it?");

/* 0000: disable about:config warning ***/
user_pref("browser.aboutConfig.showWarning", false);

/*** [SECTION 0100]: STARTUP ***/
user_pref("browser.startup.page", 0);
user_pref("browser.startup.homepage", "chrome://browser/content/blanktab.html");
user_pref("browser.newtabpage.enabled", false);
user_pref("browser.newtabpage.activity-stream.showSponsored", false);
user_pref("browser.newtabpage.activity-stream.showSponsoredTopSites", false);
user_pref("browser.newtabpage.activity-stream.showSponsoredCheckboxes", false);
user_pref("browser.newtabpage.activity-stream.default.sites", "");

/*** [SECTION 0110]: TRACKING PROTECTION ***/
user_pref("privacy.trackingprotection.enabled", true);
user_pref("privacy.trackingprotection.cryptomining.enabled", true);
user_pref("privacy.trackingprotection.socialtracking.enabled", true);

/*** [SECTION 0200]: GEOLOCATION ***/
user_pref("geo.provider.ms-windows-location", false);
user_pref("geo.provider.use_corelocation", false);
user_pref("geo.provider.use_geoclue", false);

/*** [SECTION 0300]: QUIETER FOX ***/
user_pref("extensions.getAddons.showPane", false);
user_pref("extensions.htmlaboutaddons.recommendations.enabled", false);
user_pref("browser.discovery.enabled", false);
user_pref("browser.newtabpage.activity-stream.feeds.telemetry", false);
user_pref("browser.newtabpage.activity-stream.telemetry", false);
user_pref("app.shield.optoutstudies.enabled", false);
user_pref("app.normandy.enabled", false);
user_pref("app.normandy.api_url", "");
user_pref("breakpad.reportURL", "");
user_pref("browser.tabs.crashReporting.sendReport", false);
user_pref("browser.crashReports.unsubmittedCheck.autoSubmit2", false);
user_pref("captivedetect.canonicalURL", "");
user_pref("network.captive-portal-service.enabled", false);
user_pref("network.connectivity-service.enabled", false);

/*** [SECTION 0400]: SAFE BROWSING ***/
user_pref("browser.safebrowsing.downloads.remote.enabled", false);

/*** [SECTION 0600]: BLOCK IMPLICIT OUTBOUND ***/
user_pref("network.prefetch-next", false);

user_pref("network.dns.disablePrefetchFromHTTPS", true);
user_pref("network.predictor.enabled", false);
user_pref("network.predictor.enable-prefetch", false);
user_pref("network.http.speculative-parallel-limit", 0);
user_pref("browser.places.speculativeConnect.enabled", false);

/*** [SECTION 0700]: DNS / DoH / PROXY / SOCKS ***/
user_pref("network.proxy.socks_remote_dns", true);
user_pref("network.file.disable_unc_paths", true);
user_pref("network.gio.supported-protocols", "");

/*** [SECTION 0800]: LOCATION BAR / SEARCH BAR / SUGGESTIONS / HISTORY / FORMS ***/
user_pref("browser.urlbar.speculativeConnect.enabled", false);
user_pref("browser.urlbar.quicksuggest.enabled", false);
user_pref("browser.urlbar.suggest.quicksuggest.nonsponsored", false);
user_pref("browser.urlbar.suggest.quicksuggest.sponsored", false);
user_pref("browser.search.suggest.enabled", false);
user_pref("browser.urlbar.suggest.searches", false);
user_pref("browser.urlbar.trending.featureGate", false);
user_pref("browser.urlbar.addons.featureGate", false);
user_pref("browser.urlbar.amp.featureGate", false);
user_pref("browser.urlbar.fakespot.featureGate", false);
user_pref("browser.urlbar.mdn.featureGate", false);
user_pref("browser.urlbar.weather.featureGate", false);
user_pref("browser.urlbar.wikipedia.featureGate", false);
user_pref("browser.urlbar.yelp.featureGate", false);
user_pref("browser.formfill.enable", false);
user_pref("browser.search.separatePrivateDefault", true);
user_pref("browser.search.separatePrivateDefault.ui.enabled", true);

/*** [SECTION 0900]: PASSWORDS ***/
user_pref("signon.autofillForms", false);
user_pref("signon.formlessCapture.enabled", false);
user_pref("network.auth.subresource-http-auth-allow", 1);

/*** [SECTION 1000]: DISK AVOIDANCE ***/
user_pref("browser.cache.disk.enable", true);
user_pref("browser.privatebrowsing.forceMediaMemoryCache", true);
user_pref("media.memory_cache_max_size", 65536);
user_pref("browser.sessionstore.privacy_level", 2);
user_pref("toolkit.winRegisterApplicationRestart", false);
user_pref("browser.shell.shortcutFavicons", false);

/*** [SECTION 1200]: HTTPS (SSL/TLS / OCSP / CERTS / HPKP) ***/
user_pref("security.ssl.require_safe_negotiation", true);
user_pref("security.tls.enable_0rtt_data", false);
user_pref("security.OCSP.enabled", 1);
user_pref("security.OCSP.require", true);
user_pref("security.cert_pinning.enforcement_level", 2);
user_pref("security.remote_settings.crlite_filters.enabled", true);
user_pref("security.pki.crlite_mode", 2);
user_pref("dom.security.https_only_mode", true);
user_pref("dom.security.https_only_mode_send_http_background_request", false);
user_pref("security.ssl.treat_unsafe_negotiation_as_broken", true);
user_pref("browser.xul.error_pages.expert_bad_cert", true);

/*** [SECTION 1600]: REFERERS ***/
user_pref("network.http.referer.XOriginTrimmingPolicy", 2);

/*** [SECTION 1700]: CONTAINERS ***/
user_pref("privacy.userContext.enabled", true);
user_pref("privacy.userContext.ui.enabled", true);

/*** [SECTION 2000]: PLUGINS / MEDIA / WEBRTC ***/
user_pref("media.peerconnection.ice.proxy_only_if_behind_proxy", true);
user_pref("media.peerconnection.ice.default_address_only", true);

/*** [SECTION 2400]: DOM (DOCUMENT OBJECT MODEL) ***/
user_pref("dom.disable_window_move_resize", true);

/*** [SECTION 2600]: MISCELLANEOUS ***/
user_pref("browser.download.start_downloads_in_tmp_dir", true);
user_pref("browser.helperApps.deleteTempFileOnExit", true);
user_pref("browser.uitour.enabled", false);
user_pref("devtools.debugger.remote-enabled", false);
user_pref("permissions.manager.defaultsUrl", "");
user_pref("network.IDN_show_punycode", true);
user_pref("pdfjs.disabled", false);
user_pref("pdfjs.enableScripting", false);
user_pref("browser.tabs.searchclipboardfor.middleclick", false);
user_pref("browser.contentanalysis.enabled", false);
user_pref("browser.contentanalysis.default_result", 0);
user_pref("security.csp.reporting.enabled", false);
user_pref("browser.download.useDownloadDir", false);
user_pref("browser.download.alwaysOpenPanel", false);
user_pref("browser.download.manager.addToRecentDocs", false);
user_pref("browser.download.always_ask_before_handling_new_types", true);
user_pref("extensions.enabledScopes", 5);
user_pref("extensions.postDownloadThirdPartyPrompt", false);

/*** [SECTION 2700]: ETP (ENHANCED TRACKING PROTECTION) ***/
user_pref("browser.contentblocking.category", "strict");

/*** [SECTION 2800]: SHUTDOWN & SANITIZING ***/
user_pref("privacy.sanitize.sanitizeOnShutdown", true);
user_pref("privacy.clearOnShutdown_v2.cache", true);
user_pref("privacy.clearOnShutdown_v2.historyFormDataAndDownloads", false);
user_pref("privacy.clearOnShutdown_v2.browsingHistoryAndDownloads", false);
user_pref("privacy.clearOnShutdown_v2.downloads", false);
user_pref("privacy.clearOnShutdown_v2.formdata", true);
user_pref("privacy.clearOnShutdown_v2.cookiesAndStorage", true);
user_pref("privacy.clearSiteData.cache", true);
user_pref("privacy.clearSiteData.cookiesAndStorage", false);
user_pref("privacy.clearSiteData.historyFormDataAndDownloads", false);
user_pref("privacy.clearSiteData.browsingHistoryAndDownloads", false);
user_pref("privacy.clearSiteData.formdata", true);
user_pref("privacy.clearHistory.cache", true);
user_pref("privacy.clearHistory.cookiesAndStorage", false);
user_pref("privacy.clearHistory.historyFormDataAndDownloads", false);
user_pref("privacy.clearHistory.browsingHistoryAndDownloads", false);
user_pref("privacy.clearHistory.formdata", true);
user_pref("privacy.sanitize.timeSpan", 0);

/*** [SECTION 4000]: FPP (fingerprintingProtection) ***/
user_pref("privacy.window.maxInnerWidth", 1600);
user_pref("privacy.window.maxInnerHeight", 900);

/*** [SECTION 5000]: OPTIONAL OPSEC ***/
user_pref("places.history.expiration.transient_current_max_pages", 2147483647);

/*** [SECTION 8500]: TELEMETRY ***/
user_pref("toolkit.telemetry.enabled", false);
user_pref("toolkit.telemetry.server", "");
user_pref("toolkit.telemetry.archive.enabled", false);
user_pref("toolkit.telemetry.newProfilePing.enabled", false);
user_pref("toolkit.telemetry.shutdownPingSender.enabled", false);
user_pref("toolkit.telemetry.updatePing.enabled", false);
user_pref("datareporting.healthreport.service.enabled", false);
user_pref("datareporting.healthreport.uploadEnabled", false);
user_pref("datareporting.policy.dataSubmissionEnabled", false);
user_pref("datareporting.policy.dataSubmissionPolicyBypassNotification", true);

/*** ADDITIONAL HARDENING (not in default arkenfox but recommended) ***/
// Block third-party cookies
user_pref("network.cookie.thirdparty.blockAlways", true);
user_pref("network.cookie.thirdparty.sessionOnly", true);

// Fingerprinting protection
user_pref("privacy.resistFingerprinting", true);
user_pref("webgl.disabled", true);

// Disable remote content in messages (Thunderbird)
user_pref("mailnews.message_display.disable.remote_image", true);

// Disable autocorrect/spell check for passwords
user_pref("layout.spellcheckDefault", 0);

// Allow uBlock Origin and privacy extensions to work
user_pref("extensions.webcompat.enable_interventions", true);
user_pref("extensions.webcompat.enable_shims", true);

// Disable hardware sensors
user_pref("device.sensors.enabled", false);
user_pref("device.sensors.motion.enabled", false);

// Disable Gamepad API
user_pref("dom.gamepad.enabled", false);

// Disable WebDriver
user_pref("webdriver.disabled", true);

// Disable Battery API
user_pref("dom.battery.enabled", false);

// Disable IPv6
user_pref("network.dns.disableIPv6", true);

// Keep safe browsing (local lookups, privacy-preserving)
user_pref("browser.safebrowsing.enabled", true);
user_pref("browser.safebrowsing.malware.enabled", true);
user_pref("browser.safebrowsing.phishing.enabled", true);

// Disable autofill for passwords
user_pref("signon.autofillForms", false);
user_pref("browser.formfill.enable", false);

// Disable link ping
user_pref("browser.send_pings", false);

// Disable TCP Fast Open
user_pref("network.tcp.fast_open", false);

// Disable URL bar ad suggestions
user_pref("browser.urlbar.suggest.quicksuggest.enabled", false);

// Disable Pocket and sponsored content
user_pref("browser.newtab.activity-stream.feeds.section.topstories", false);
user_pref("browser.newtab.activity-stream.showSponsored", false);

// Disable telemetry in URL bar
user_pref("browser.urlbar.telemetry", false);

// Enable TLS 1.3 only
user_pref("security.tls.version.max", 4);

// Disable Firefox Suggestions
user_pref("browser.urlbar.suggest.firefoxSuggest", false);

// Minimum TLS version
user_pref("security.tls.version.min", 3);

// Network settings
user_pref("network.http.pipelining", true);
user_pref("network.http.pipelining.maxrequests", 8);
user_pref("network.http.proxy.pipelining", true);
user_pref("network.dns.disablePrefetch", false);
user_pref("browser.tabs.animate", false);
user_pref("browser.tabs.showThrobbers", false);
user_pref("browser.tabs.unloadOnLowMemory", false);
user_pref("network.http.max-connections", 24);
user_pref("network.http.max-connections-per-server", 8);

// Cache settings
user_pref("browser.cache.disk.enable", true);
user_pref("browser.cache.memory.enable", true);
user_pref("browser.cache.disk.capacity", 358400);

// Proxy
user_pref("network.proxy.type", 0);

/*** [SECTION 9000]: PERFORMANCE (no privacy/security impact) ***/
// HTTP/2 and connection settings
user_pref("network.http.http2.enabled", true);
user_pref("network.http.http2.connection-management", 1);
user_pref("network.http.max-persistent-connections-per-server", 6);
user_pref("network.http.max-persistent-connections-per-proxy", 6);

// Faster tab switching
user_pref("browser.tabs.selectOnLastClose", true);
user_pref("browser.tabs.unloadOnLowMemory", false);

// Rendering performance
user_pref("layers.acceleration.force-enabled", true);
user_pref("gfx.canvas.accelerated", true);
user_pref("gfx.content.skia-font-cache", true);

// Faster DOM
user_pref("dom.min_background_timeout_value", 1000);
user_pref("dom.max_script_run_time", 30);

// Font rendering
user_pref("gfx.font_rendering.cleartype_params.rendering_mode", 5);

// Faster JavaScript
user_pref("javascript.options.ion", true);
user_pref("javascript.options.baselinejit", true);

// Memory
user_pref("memory.low_physical_memory_threshold_proxy", 1073741824); // 1GB threshold

// WebSocket performance
user_pref("network.websocket.max-connections", 30);

// Search
user_pref("browser.search.geoip.timeout", 3000);

/*** END ***/
user_pref("_user.js.parrot", "END: Oh yes, the Norwegian Blue... what's wrong with it?");
