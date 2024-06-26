//
//  LoginTarget.swift
//  MID
//
//  Created by 천성우 on 6/4/24.
//

import Foundation

import Moya
import RxCocoa
import RxMoya
import RxSwift

enum AuthTarget {
    case signUp(param: SignUpRequestBody)
    case login(param: LoginRequestBody)
    case duplicateCheck(studentNo: String)
    case logOut
    case delUser
    case tokenRefresh
}

extension AuthTarget: BaseTargetType {
    
    var headers: [String : String]? {
        APIConstants.headerWithAuthorization
    }
    
    var authorizationType: AuthorizationType? {
        return .bearer
    }
    
    var path: String {
        switch self {
        case .signUp:
            return URLConstant.signUp
        case .login:
            return URLConstant.login
        case .duplicateCheck(let studentNo):
            let newPath = URLConstant.duplicate
                .replacingOccurrences(of: "{studentNo}", with: String(studentNo))
            return newPath
        case .logOut:
            return URLConstant.loginOut
        case .delUser:
            return URLConstant.userDelete
            
        case .tokenRefresh:
             return URLConstant.tokenRefresh
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .signUp, .login, .logOut:
            return .post
        case .duplicateCheck, .tokenRefresh:
            return .get
        case .delUser:
            return .delete
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .signUp(let parameter):
            let parameters = try! parameter.asParameter()
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .login(let parameter):
            let parameters = try! parameter.asParameter()
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .duplicateCheck, .logOut, .delUser, .tokenRefresh:
            return .requestPlain
        }
    }
}

struct AuthService: Networkable {
    typealias Target = AuthTarget
    private static let provider = makeProvider()
    
    
    /**
     회원가입을 합니다.
     - parameter userData: SignUpRequestBody
     */
    
    static func postSignUp(userData: SignUpRequestBody) -> Observable<SignUpResponseBody> {
        return provider.rx.request(.signUp(param: userData))
            .asObservable()
            .mapError()
            .retryOnTokenExpired()
            .decode(decodeType: SignUpResponseBody.self)
    }
    
    /**
     로그인을 합니다.
     - parameter userData: SignUpRequestBody
     */
    
    static func postLogin(userData: LoginRequestBody) -> Observable<LoginResponseBody> {
        return provider.rx.request(.login(param: userData))
            .asObservable()
            .mapError()
            .retryOnTokenExpired()
            .decode(decodeType: LoginResponseBody.self)
    }
    
    /**
     회원가입시 학번 중복 검사를 진행합니다
     - parameter studentNo: string
     */
    
    static func getDuplicateCheck(with studentNo: String) -> Observable<[DuplicateResponseBody]> {
        return provider.rx.request(.duplicateCheck(studentNo: studentNo))
            .asObservable()
            .mapError()
            .retryOnTokenExpired()
            .decode(decodeType: [DuplicateResponseBody].self)
    }
    
    /**
     로그아웃을 요청합니다
     */
    
    static func postLogOut() -> Observable<[LogOutResponseBody]> {
        return provider.rx.request(.logOut)
            .asObservable()
            .mapError()
            .retryOnTokenExpired()
            .decode(decodeType: [LogOutResponseBody].self)
    }

    /**
     회원탈퇴를 요청합니다
     */
    
    static func deleteUser() -> Observable<[UserDeleteResponseBody]> {
        return provider.rx.request(.delUser)
            .asObservable()
            .mapError()
            .retryOnTokenExpired()
            .decode(decodeType: [UserDeleteResponseBody].self)
    }
    
    
}

