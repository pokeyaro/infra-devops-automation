#!/usr/bin/env python2
# -*- coding: UTF-8 -*-
import syslog

def auth_log(msg):
    syslog.syslog("OTP-PAM-AUTH: " + msg)


def auth_otp(pamh, user):
    """
    A one-time password (OTP), also known as a one-time PIN.
    """
    # 3 attempts to enter the one time PIN
    for attempt in range(0, 3):
        msg = pamh.Message(pamh.PAM_PROMPT_ECHO_OFF, "Enter 2-factor auth: ")
        response = pamh.conversation(msg)
        if response.resp == "helloworld":
            auth_log("user: {0} login successful with PIN.".format(user))
            return pamh.PAM_SUCCESS
        else:
            auth_log("user: {0} login failed with PIN.".format(user))
            continue
            return pamh.PAM_AUTH_ERR


def pam_sm_authenticate(pamh, flags, argv):
    """
    Determine the 2FA string entered by the user.
    """
    try:
        # Get the user to log in
        user = pamh.get_user()
    except pamh.exception, e:
        return e.pam_result

    if not user:
        msg = pamh.Message(pamh.PAM_ERROR_MSG, "Unable to send one time PIN.\nPlease contact your System Administrator.")
        pamh.conversation(msg)
        return pamh.PAM_USER_UNKNOWN

    result = auth_otp(pamh, user)
    return result


"""
default function
"""
def pam_sm_setcred(pamh, flags, argv):
    return pamh.PAM_SUCCESS

def pam_sm_acct_mgmt(pamh, flags, argv):
    return pamh.PAM_SUCCESS

def pam_sm_open_session(pamh, flags, argv):
    msg = pamh.Message(pamh.PAM_ERROR_MSG, "hello.")
    pamh.conversation(msg)
    return pamh.PAM_SUCCESS

def pam_sm_close_session(pamh, flags, argv):
    return pamh.PAM_SUCCESS

def pam_sm_chauthtok(pamh, flags, argv):
    return pamh.PAM_SUCCESS
