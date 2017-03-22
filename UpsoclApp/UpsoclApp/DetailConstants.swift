//
//  DetailConstants.swift
//  appupsocl
//
//  Created by upsocl on 04-11-16.
//  Copyright © 2016 AppCoda. All rights reserved.
//
import UIKit
import Foundation
class DetailConstants {
    
    struct PropertyKey {
        static let  META_TAG = "<meta name='viewport' content='width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no' >"
        static let STYLES = "<link rel='stylesheet' type='text/css' media='all' href='http://www.upsocl.com/wp-content/themes/upsoe4/style.css'>"
        static let FONTS =  "<link href='https://fonts.googleapis.com/css?family=Roboto:400,300,500,700,400italic,300italic' rel='stylesheet' type='text/css'> "
        
        
        static let head =  "<head>" +
        "<meta charset=\"utf-8\"> <link rel=\"canonical\" href=\"http://www.upsocl.com/verde/17-perros-empapados-que-estan-demasiado-relajados-y-que-saben-disfrutar-al-maximo-la-hora-del-bano/\">" +
        "<meta property=\"op:markup_version\" content=\"v1.0\">" +
        "<meta property=\"og:site_name\" content=\"Upsocl\">" +
        "<meta property=\"fb:op-recirculation-ads\" content=\"placement_id=752942558166620_1114489955345210\">" +
        "<meta property=\"article:publisher\" content=\"https://www.facebook.com/Upsocl\">" +
        "<meta property=\"fb:app_id\" content=\"367087496758242\">" +
        "<meta property=\"fb:use_automatic_ad_placement\" content=\"true\">  </head>"
        
       // static let HTML_HEAD = "<html>"+head+"<body>"
        
        static let HTML_HEAD = META_TAG + STYLES + FONTS

        
        //static let HTML_HEAD =  "<html><head> <meta charset=\"utf-8\"> <link rel=\"canonical\" href=\"http://www.upsocl.com/verde/perros-se-ayudan-mutuamente-a-calmarse-tras-ser-maltratados-tristemente-deben-separarse/  \"> <meta property=\"op:markup_version\" content=\"v1.0\"> <meta property=\"og:site_name\" content=\"Upsocl\"> <meta property=\"fb:op-recirculation-ads\" content=\"placement_id=752942558166620_1114489955345210\"> <meta property=\"article:publisher\" content=\"https://www.facebook.com/Upsocl\"> <meta property=\"fb:app_id\" content=\"367087496758242\"> <meta property=\"fb:use_automatic_ad_placement\" content=\"true\"> </head> <body>"
    }
}
