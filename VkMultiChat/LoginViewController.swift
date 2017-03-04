//
//  LoginControllerViewController.swift
//  VkMultiChat
//
//  Created by Александр Смоленский on 14.02.17.
//  Copyright © 2017 Александр Смоленский. All rights reserved.
//

import UIKit
import VK_ios_sdk

class LoginViewController: UIViewController, NodeProtocol {
    
    var viewModel: LoginViewModel!
    
    required init(viewModel: Any) {
        super.init(nibName: "LoginViewController", bundle: nil)
        self.viewModel = viewModel as! LoginViewModel
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        VKSdk.instance().uiDelegate = self
        VKSdk.instance().register(viewModel)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Actions -
    
    @IBAction func loginWithLoginAndPass(_ sender: UIButton) {
        VKAuthorizeController.presentForAuthorize(withAppId: "5875924", andPermissions: viewModel.services.SCOPE, revokeAccess: false, displayType: VK_DISPLAY_IOS)
    }

    @IBAction func loginWithApp(_ sender: UIButton) {
        VKSdk.authorize(viewModel.services.SCOPE)
    }
    
}

extension LoginViewController: VKSdkUIDelegate {
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        present(controller, animated: true, completion: nil)
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        if let captchaVC = VKCaptchaViewController.captchaControllerWithError(captchaError) {
            present(captchaVC, animated: true, completion: nil)
        }
    }
}
