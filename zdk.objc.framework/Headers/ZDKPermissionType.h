# import <Foundation/Foundation.h>

/** \brief Types of features can be used from the ZDK
*/
typedef NS_ENUM(int, ZDKPermissionType)
{

	pt_Sip = 0,

	pt_SipTcpTls,

	pt_Blf,

	pt_Zrtp,

	pt_UserCertificate,

	pt_Kpml,

	pt_Cisco,

	pt_Srtp,

	pt_ForceRfc3264,

	pt_CiscoServerForward,

	pt_Iax,

	pt_IaxUrlFromNetwork,

	pt_Xmpp,

	pt_HttpPhoneControl,

	pt_Msrp,

	pt_Conference,

	pt_General,

	pt_RingWhenTalking,

	pt_PopupNotifications,

	pt_Provision,

	pt_GoogleAnalytics,

	pt_PcSpeakerRing,

	pt_CustomRingtone,

	pt_Firewall,

	pt_StartWithOs,

	pt_CheckUpdates,

	pt_Click2Dial,

	pt_DisableRingback,

	pt_GuiFeatures,

	pt_ChangeSkin,

	pt_ChangeBackground,

	pt_CommandLine,

	pt_CommandLineDial,

	pt_CommandLineHang,

	pt_Call,

	pt_CallRecording,

	pt_WidebandCodecs,

	pt_MuteOnEarlyMedia,

	pt_Video,

	pt_Dnid,

	pt_UnattendedCallTransfer,

	pt_AttendedCallTransfer,

	pt_LimitCallCount,

	pt_DirectDialing,

	pt_DirectDialingSip,

	pt_DirectDialingIax,

	pt_Account,

	pt_AccountRingtone,

	pt_OverlapDialing,

	pt_NumberRewriting,

	pt_StripDialChars,

	pt_AccountBalance,

	pt_AccountCallRate,

	pt_AccountCallQualityRating,

	pt_Preconditions,

	pt_VideoFmtp,

	pt_RtcpFeedback,

	pt_VoiceMailCheck,

	pt_VoiceMailTransfer,

	pt_InbandDtmf,

	pt_LimitAccountCount,

	pt_Automation,

	pt_AutoAnswer,

	pt_ServerAutoAnswer,

	pt_Forwarding,

	pt_OpenUrlOnEvent,

	pt_AutoReject,

	pt_RejectAnonymousCalls,

	pt_Chat,

	pt_ChatSession,

	pt_Presence,

	pt_Sms,

	pt_MsrpFileTransfer,

	pt_Contacts,

	pt_ContactsLocal,

	pt_ContactsLdap,

	pt_ContactsOutlook,

	pt_ContactsMac,

	pt_ContactsJabber,

	pt_ContactsGoogle,

	pt_ContactsWindows,

	pt_ContactsXml,

	pt_ContactsCsvImport,

	pt_ExternalDevices,

	pt_HandsetGeneric,

	pt_HandsetPlantronics,

	pt_HandsetYealink,

	pt_HandsetJabra,

	pt_HandsetSennheiser,

	pt_Integration,

	pt_OutlookPlugin,

	pt_AppleAddressbookPlugin,

	pt_ProtocolHandlers,

	pt_Codec,

	pt_CodecPcmu,

	pt_CodecGsm,

	pt_CodecPcma,

	pt_CodecG729,

	pt_CodecSpeexNarrow,

	pt_CodecIlbc20,

	pt_CodecOpusNarrow,

	pt_CodecAmr,

	pt_CodecVideo,

	pt_CodecH263,

	pt_CodecH263_plus,

	pt_CodecVp8,

	pt_CodecH264,

	pt_CodecH264Hw,

	pt_CodecWideband,

	pt_CodecG722,

	pt_CodecSpeexWide,

	pt_CodecSpeexUltra,

	pt_CodecG726,

	pt_CodecOpusWide,

	pt_CodecOpusSuper,

	pt_CodecOpusFull,

	pt_CodecAmrWb,

	pt_Premium,

	pt_PermissionTypeCount,
};
