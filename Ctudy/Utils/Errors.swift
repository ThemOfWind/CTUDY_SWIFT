//
//  Errors.swift
//  Ctudy
//
//  Created by 김지은 on 2021/12/12.
//

import Foundation

enum AuthErrors: String, Error {
    case existed = "이미 사용중입니다."
    case existedUserName = "이미 사용된 아이디입니다."
    case existedEmail = "이미 사용된 이메일입니다."
    case noSignUp = "회원가입에 실패하였습니다."
    case noSignIn = "아이디 및 비밀번호가 일치하지 않습니다."
    case noLogout = "로그아웃에 실패하였습니다. (token 인증처리 실패)"
    case noSaveToken = "토큰 값 저장에 실패했습니다."
    case noDelToken = "토큰 값 삭제에 실패했습니다."
    case noProfile = "회원정보를 가져오지 못했습니다."
    case noSearchid = "연결된 아이디를 찾을 수 없습니다."
    case noUpdateProfileImage = "프로필 이미지 변경에 실패했습니다."
    case noUpdateProfileName = "닉네임 변경에 실패했습니다."
}

enum RoomErrors: String, Error {
    case noSearchRoom = "스터디룸 조회에 실패했습니다."
    case noRegisterRoom = "스터디룸 등록에 실패했습니다."
    case noSearchMemeber = "스터디룸 회원 조회에 실패했습니다."
    case noUpdateRoomImage = "스터디룸 이미지 변경에 실패했습니다."
    case noUpdateRoom = "스터디룸 설정 변경에 실패했습니다."
}

enum MemberErrors: String, Error {
    case noSearchMember = "전체 회원 조회에 실패했습니다."
}

enum CouponErrors: String, Error {
    case noCreateCoupon = "쿠폰 등록에 실패했습니다."
}
