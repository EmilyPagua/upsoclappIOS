//
//  DetailConstants.swift
//  UpsoclApp
//
//  Created by upsocl on 04-11-16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import Foundation
import UIKit

class DetailConstants {
    
    struct PropertyKey {
        static let  META_TAG = "<meta name='viewport' content='width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no'>"
        static let STYLES = "<link rel='stylesheet' type='text/css' media='all' href='http://www.upsocl.com/wp-content/themes/upso3/style.css'>"
        static let FONTS = "<link href='http://fonts.googleapis.com/css?family=Droid+Sans:400,700' rel='stylesheet' type='text/css'><link href='http://fonts.googleapis.com/css?family=Raleway:400,600' rel='stylesheet' type='text/css'>"
        static let HTML_HEAD = META_TAG + STYLES + FONTS
        
        
        static let top = "<html> <header> <meta name='viewport' content='width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no'> <link rel='stylesheet' type='text/css' media='all' href='http://www.upsocl.com/wp-content/themes/upso3/style.css'> <link href='http://fonts.googleapis.com/css?family=Droid+Sans:400,700' rel='stylesheet' type='text/css'> <link href='http://fonts.googleapis.com/css?family=Raleway:400,600' rel='stylesheet' type='text/css'> <script type='text/javascript'>(function() {var useSSL = 'https:' == document.location.protocol;var src = (useSSL ? 'https:' : 'http:') + '//www.googletagservices.com/tag/js/gpt.js';document.write('<scr' + 'ipt src=\"' + src + '\"> </scr' + 'ipt>');})(); </script> <script> var mappingCT = googletag.sizeMapping().addSize([300, 100], [300, 250]). addSize([760, 200], [728, 90]). build(); var mappingCA = googletag.sizeMapping().addSize([300, 100], [300, 250]). addSize([760, 200], [728, 90]). build(); googletag.defineSlot('/100064084/contenidotop', [[300, 250], [728, 90]], 'div-gpt-ad-ct').defineSizeMapping(mappingCT).addService(googletag.pubads());  googletag.defineSlot('/100064084/contenidoabajo', [[300, 250], [728, 90]], 'div-gpt-ad-ca').defineSizeMapping(mappingCA).addService(googletag.pubads());  googletag.pubads().collapseEmptyDivs();  googletag.pubads().enableSyncRendering();googletag.enableServices(); </script> </header> <body>  "
        
        let banner_up  = "<div id='div-gpt-ad-ct' align='center' > <script> googletag.cmd.push(function() { googletag.display('div-gpt-ad-ct') }); </script> </div>"
        let banner_bot = "<div id='div-gpt-ad-ca' align='center' > <script> googletag.cmd.push(function() { googletag.display('div-gpt-ad-ca') }); </script> </div> "
        

    }
    
}
