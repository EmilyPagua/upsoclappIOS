//
//  AboutUsViewController.swift
//  UpsoclApp
//
//  Created by upsocl on 21-09-16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit

class AboutUsViewController: UIViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var webContent: UIWebView!

    let content = "<p align='center'><a href='http://www.upsocl.com/wp-content/themes/upso2/images/logo.png'><img alt='' src='http://www.upsocl.com/wp-content/themes/upso2/images/logo.png' style='width: 260px; height: 74px;'/></a></p><p align='justify'>&iquest;Qu&eacute; pasar&iacute;a si dejamos de usar Internet para ver a un perro persiguiendo su cola o una persona cay&eacute;ndose a un r&iacute;o y empez&aacute;ramos a usarlo para <strong>esparcir ideas que puedan cambiar la forma en que vemos el mundo</strong>? &iquest;Qu&eacute; pasar&iacute;a si tomamos esa enorme cantidad de ideas que no est&aacute;n disponibles en espa&ntilde;ol y elimin&aacute;ramos la brecha del idioma?&hellip; As&iacute; naci&oacute; Upsocl</p><p align='justify'>Somos una compa&ntilde;&iacute;a de medios con la misi&oacute;n de volver a <strong>conectar a las personas a trav&eacute;s de Internet</strong>. Nuestras ideas y forma de ver el mundo, no intentan ser un campa&ntilde;a pol&iacute;tica, sino que buscan generar movimiento y conciencia en nuestra sociedad</p><h3 align='justify'><strong>&iquest;Qu&eacute; significa Upsocl?</strong></h3><p align='justify'>Ten&iacute;amos una idea y misi&oacute;n muy clara de lo que quer&iacute;amos hacer, faltaba el nombre&hellip; Upsocl es la uni&oacute;n de dos palabras: <strong>&#39;up&#39;</strong>, arriba en ingl&eacute;s y nuestra propia versi&oacute;n de la abreviaci&oacute;n de <strong>&#39;social&#39;</strong>. Pero t&uacute; le puedes decir como quieras</p><h3 align='justify'><strong>&iquest;De donde somos?</strong></h3><p align='justify'>Nos preguntan con frecuencia de donde es Upsocl. Si bien, por el momento trabajamos desde Chile, Colombia y Panam&aacute;, para ser justos Upsocl le pertenece toda la comunidad hispano parlante.</p>"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //controller buttonMenu
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        webContent.loadHTMLString(content, baseURL: nil)
    }
}
