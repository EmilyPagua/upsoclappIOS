//
//  PoliticasPrivacityViewController.swift
//  UpsoclApp
//
//  Created by upsocl on 21-09-16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit

class PoliticasPrivacityViewController: UIViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var webViewContent: UIWebView!
    
    var progressBar = ProgressBarLoad()
    var indicator : UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
    
    let pagePolitcs = "<p align='justify'>Upsocl, es una compa&ntilde;&iacute;a de medios con la misi&oacute;n de volver a conectar a las personas a trav&eacute;s de Internet. Nuestras ideas y forma de ver el mundo, no intentan ser una campa&ntilde;a pol&iacute;tica, sino que buscan generar movimiento y conciencia en nuestra sociedad, la presente pol&iacute;tica de privacidad fue actualizada el 08 de agosto de 2016; es posible que actualicemos las pol&iacute;ticas se seguridad en las pr&oacute;ximas versiones de la aplicaci&oacute;n, por lo que es recomendable leer la misma con regularidad para mantenerse informado.</p><p align='justify'>El objetivo de esta Pol&iacute;tica de privacidad es informarle sobre los datos que recogemos, los motivos por los que los recogemos y lo que hacemos con ellos. Esta informaci&oacute;n es importante, por lo que esperamos que dediques el tiempo necesario para leerla detenidamente, esto con la finalidad de brindar la total seguridad de que usted est&aacute; en una aplicaci&oacute;n que protege su informaci&oacute;n e identidad.</p><p align='justify'><strong>Seguridad y protecci&oacute;n de datos personales</strong>: La seguridad de sus datos personales es una prioridad para esta aplicaci&oacute;n m&oacute;vil, la cual ofrece seguridad total. Sin embargo, no nos responsabilizamos por las actividades de hackers o terceros que realizan acciones para da&ntilde;ar y romper la seguridad. Teniendo en consideraci&oacute;n las caracter&iacute;sticas t&eacute;cnicas de transmisi&oacute;n de informaci&oacute;n a trav&eacute;s de Internet, ning&uacute;n sistema es 100% seguro o exento de ataques.</p><p align='justify'><strong>Privacidad</strong>: esta aplicaci&oacute;n respeta la privacidad de cada uno de sus visitantes. Toda informaci&oacute;n ingresada por el usuario a trav&eacute;s de nuestra aplicaci&ograve;n movila, ser&aacute; tratada con la mayor seguridad, y s&oacute;lo ser&aacute; usada de acuerdo con las limitaciones establecidas en este documento.</p><p align='justify'><strong>Obtenci&oacute;n de informaci&oacute;n</strong>: Esta aplicaci&oacute;n obtiene los datos personales suministrados directa, voluntaria y conscientemente por cada usuario. La informaci&oacute;n personal que solicitamos corresponde a datos b&aacute;sicos, los cuales ser&aacute;n adquiridos en la informaci&oacute;n obtenida seg&uacute;n la red social con la que se inicie sesi&oacute;n .</p><p align='justify'><strong>Uso de la informaci&oacute;n</strong>: Al suministrar datos personales, autom&aacute;ticamente estar&aacute; autorizandonos para usar sus datos personales de conformidad con nuestra Pol&iacute;tica de Privacidad, lo cual comprende los siguientes eventos:</p><ol style='margin-top:0pt;margin-bottom:0pt;'><li align='justify'>para incrementar nuestra oferta al mercado y hacer publicidad de productos que pueden ser de sumo inter&eacute;s para el usuario; incluyendo los llamados para confirmaci&oacute;n de su informaci&oacute;n;</li><li align='justify'>para personalizar y mejorar nuestros productos y servicios.</li><li align='justify'>para enviar correos electr&oacute;nicos con nuestros boletines, responder inquietudes o comentarios, y mantener informado a nuestros usuarios.</li></ol><p align='justify'><strong>Acceso a su informaci&oacute;n</strong>: La aplicaci&oacute;n m&oacute;vil Upsocl, tiene el compromiso permanente de presentar nuevas soluciones que mejoren el valor de sus productos y servicios; con el objeto de ofrecer oportunidades especiales de mercado, como incentivos, promociones y novedades actualizadas. Upsocl.com no comercializa, vende ni alquila su base de datos a otras empresas.</p><p align='justify'><strong>Revelaci&oacute;n de informaci&oacute;n</strong>: En ning&uacute;n momento se utiliza o revela a terceros, la informaci&oacute;n individual de los usuarios as&iacute; como los datos sobre las visitas, o la informaci&oacute;n que nos proporcionan: nombre, direcci&oacute;n, direcci&oacute;n de correo electr&oacute;nico, localizaci&oacute;n, fecha de nacimiento, etc.</p><p align='justify'><strong>Modificaciones a nuestra Pol&iacute;tica de Privacidad</strong>: La Aplicaci&oacute;n M&oacute;vil Upsocl, se reserva en forma exclusiva el derecho de modificar, rectificar, alterar, agregar o eliminar cualquier punto del presente escrito en cualquier momento y sin previo aviso.</p>"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //loadProgressBar
        indicator = progressBar.loadBar()
        view.addSubview(indicator)
        indicator.bringSubviewToFront(view)
        
        //controller buttonMenu
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        self.indicator.startAnimating()
        webViewContent.loadHTMLString(pagePolitcs, baseURL: nil)
        
    }
    
}
