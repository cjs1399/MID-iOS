//
//  EditMyPageViewController.swift
//  MID
//
//  Created by 천성우 on 5/23/24.
//

import UIKit

import Then
import SnapKit
import RxSwift
import RxCocoa

final class DetailsUserInfoViewController: BaseViewController {
    
    
    private let viewModel: MyPageViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: - UI Components
    
    private let detailsUserInfoView = DetailsUserInfoView(frame: .zero, name: "천성우", department: "IT융합자율학부")
    
    
    // MARK: - Properties
    
    
    // MARK: - Initializer

    init(viewModel: MyPageViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func bindViewModel() {
        detailsUserInfoView.withdrawalButton.rx.tap
            .bind { [weak self] in
                guard let self else { return }
                self.viewModel.inputs.withdrawalDidTap()
                self.didTapSignOut()
            }
            .disposed(by: disposeBag)
    }
    
    override func setStyles() {
        view.backgroundColor = .gray600
        
    }
    
    override func setLayout() {
        view.addSubviews(detailsUserInfoView)
        
        detailsUserInfoView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    private func didTapSignOut() {
        let finishedAlertView = MyPageAlertViewController(alertType: .signOut)
        finishedAlertView.modalPresentationStyle = .overFullScreen
        self.present(finishedAlertView, animated: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

