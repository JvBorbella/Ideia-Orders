import 'package:flutter/material.dart';

class Style {
//Cores usadas na aplicação {
  static const Color defaultColor = Color(0xfff8f9fe);
  static const Color primaryColor = Color(0xff00568e);
  static const Color secondaryColor = Color(0xff42b9f0);
  static const Color tertiaryColor = Color(0xffffffff);
  static const Color quarantineColor = Color(0xffA6A6A6);
  static const Color sucefullColor = Colors.green;
  static const Color errorColor = Color.fromARGB(255, 156, 30, 21);
  static const Color warningColor = Color(0xffFFD700);
//}

//Tamanhos dinâmicos dos elementos da tela splash_page {
  static double TextSplashSize(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.035;
  }

  static double LogoSplashSize(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.25;
  }
//}

//Tamanho dinâmico dos elementos da tela login_page & config_page {
  static double logoSize(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.12;
  }

  static double ActionButtonSize(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.03;
  }

  static double InputSpace(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.04;
  }

  static double InputToButtonSpace(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.07;
  }

  static double ButtonToButtonSpaceHeight(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.01;
  }

  static double ButtonToButtonSpaceWidth(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.09;
  }

  static double SaveUrlMessageSize(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.018;
  }

  static double SaveUrlMessagePadding(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.0192;
  }
//}

//Tamanho dinâmico de elementos globais da aplicação {
  static double NavbarSize(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.06;
  }

  static double TextNavbarSize(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.02;
  }

  static double CircularProgressIndicatorWidth(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.112;
  }

  static double CircularProgressIndicatorSize(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.0096;
  }
//}



//Tamanho dinâmico dos elementos de sales_page {
  static double TextDetailsSize(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.0128;
  }

  static double SalesCardSpace(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.016;
  }

  static double PeriodTitleSpace(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.008;
  }

  static double IconVerifiedSize(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.0256;
  }
//}

//Tamanhos dinâmicos dos elementos da home_page {
  static double RequestButtonWidth(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.256;
  }

  static double CompanyNameButtonSize(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.0256;
  }

  static double CompanyNameButtonMargin(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.0128;
  }

  static double CompanyNameButtonBorderRadius(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.032;
  }

  static double RequestButtonHeight(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.07;
  }

  static double TextRequestButtonHeight(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.0192;
  }

  static double ConditionalTextSize(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.016;
  }

  static double NumberOfRequestsSize(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.0208;
  }

  static double BackgroundNumberOfRequestsSize(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.032;
  }

  static double TextRequests(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.0288;
  }

  static double TextButtonExitSize(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.0255;
  }
   //Tamanhos dinâmicos da aba Drawer {
      static double PaddingDrawerButton(BuildContext context) {
        return MediaQuery.of(context).size.height * 0.015;
      }

      static double SizeDrawerButton(BuildContext context) {
        return MediaQuery.of(context).size.height * 0.032;
      }

      static double CompanyNameSalesPageSize(BuildContext context) {
        return MediaQuery.of(context).size.height * 0.035;
      }

      static double AccountEmailSize(BuildContext context) {
        return MediaQuery.of(context).size.width * 0.2;
      }

      static double AccountNameWidth(BuildContext context) {
        return MediaQuery.of(context).size.width * 0.144;
      }

      static double AccountNameHeight(BuildContext context) {
        return MediaQuery.of(context).size.height * 0.095;
      }

      static double IconCloseDrawerSize(BuildContext context) {
        return MediaQuery.of(context).size.height * 0.048;
      }

      static double LoginFontSize(BuildContext context) {
        return MediaQuery.of(context).size.height * 0.0322;
      }

      static double EmailFontSize(BuildContext context) {
        return MediaQuery.of(context).size.height * 0.0128;
      }

      static double PaddingContainerDrawerHeader(BuildContext context) {
        return MediaQuery.of(context).size.width * 0.0192;
      }

      static double DrawerHeaderSize(BuildContext context) {
        return MediaQuery.of(context).size.height * 0.24;
      }

      static double ButtonDrawerSize(BuildContext context) {
        return MediaQuery.of(context).size.height * 0.024;
      }

      static double ButtonDrawerSpace(BuildContext context) {
        return MediaQuery.of(context).size.height * 0.016;
      }

      static double PaddingAccountName(BuildContext context) {
        return MediaQuery.of(context).size.height * 0.048;
      }

      //Tamanhos dinâmicos dos elementos de modal_button {
          static double ModalButtonPadding(BuildContext context) {
            return MediaQuery.of(context).size.width * 0.005;
          }

          static double ModalButtonHeight(BuildContext context) {
            return MediaQuery.of(context).size.height * 0.04;
          }

          static double ModalButtonWidth(BuildContext context) {
            return MediaQuery.of(context).size.width * 0.16;
          }

          static double TextModalButtonSize(BuildContext context) {
            return MediaQuery.of(context).size.height * 0.0224;
          }

          static double IconModalButtonSize(BuildContext context) {
            return MediaQuery.of(context).size.height * 0.032;
          }

          static double ModalButtonSpace(BuildContext context) {
            return MediaQuery.of(context).size.height * 0.012;
          }

          static double ModalSize(BuildContext context) {
            return MediaQuery.of(context).size.height * 0.32;
          }

          static double ModalWidth(BuildContext context) {
            return MediaQuery.of(context).size.width * 5;
          }

          static double TextExitConfirmation(BuildContext context) {
          return MediaQuery.of(context).size.height * 0.0256;
          }

          static double ButtonExitWidth(BuildContext context) {
            return MediaQuery.of(context).size.height * 0.128;
          }

          static double ButtonCancelWidth(BuildContext context) {
            return MediaQuery.of(context).size.height * 0.175;
          }

          static double ButtonExitHeight(BuildContext context) {
            return MediaQuery.of(context).size.height * 0.088;
          }

          static double ButtonCancelHeight(BuildContext context) {
            return MediaQuery.of(context).size.height * 0.088;
          }

          static double ButtonExitPadding(BuildContext context) {
            return MediaQuery.of(context).size.height * 0.024;
          }

          static double ButtonCancelPadding(BuildContext context) {
            return MediaQuery.of(context).size.height * 0.024;
          }

          static double ButtonExitBorderRadius(BuildContext context) {
            return MediaQuery.of(context).size.height * 0.016;
          }

          static double ButtonCancel(BuildContext context) {
            return MediaQuery.of(context).size.height * 0.016;
          }

          static double PaddingModal(BuildContext context) {
            return MediaQuery.of(context).size.height * 0.0128;
          }

          static double InternalModalSize(BuildContext context) {
            return MediaQuery.of(context).size.height * 0.24;
          }

          static double InternalModalPadding(BuildContext context) {
            return MediaQuery.of(context).size.height * 0.0192;
          }

          static double ModalMargin(BuildContext context) {
            return MediaQuery.of(context).size.height * 0.016;
          }

          static double ModalBorderRadius(BuildContext context) {
            return MediaQuery.of(context).size.height * 0.016;
          }
        //}
    //}
//}

 
//Tamanho dinâmico dos elementos de request_page { 
  static double ImageProfileRequestSize(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.112;
  }

  static double ContainerImageProfileRequestSize(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.05;
  }

  static double BorderRadiusContainerImage(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.04;
  }

  static double WidthBorderImageContainer(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.0032;
  }

  static double UserLoginSize(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.035;
  }

  static double ContainerUserLoginSize(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.4;
  }

  static double UserCompanySize(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.025;
  }

  static double ContainerUserCompanySize(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.4;
  }

  static double DeleteButtonSize(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.032;
  }

  static double TextSolicitacionSize(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.0192;
  }

  static double BorderAuthorizationButtonCircular(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.008;
  }
//}

  
//Espaçamentos globais {
  static double height_05(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.0008;
  }

  static double height_1(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.0016;
  }

  static double height_2(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.0032;
  }

  static double height_5(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.008;
  }

  static double height_7(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.008;
  }

  static double height_8(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.0128;
  }

  static double height_10(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.016;
  }

  static double height_12(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.0192;
  }

  static double height_15(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.024;
  }

  static double height_20(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.032;
  }

  static double height_25(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.04;
  }

  static double height_30(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.048;
  }

  static double height_35(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.056;
  }

  static double height_40(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.064;
  }

  static double height_45(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.072;
  }

  static double height_50(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.08;
  }

  static double height_55(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.088;
  }

  static double height_60(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.096;
  }

  static double height_70(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.112;
  }

  static double height_80(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.128;
  }

  static double width_80(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.2222222222222222;
  }

  static double height_100(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.16;
  }

  static double height_130(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.208;
  }

  static double width_130(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.3611111111111111;
  }

  static double height_150(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.24;
  }

  static double width_150(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.24;
  }

  static double width_280(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.456;
  }

  static double height_165(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.264;
  }

  static double height_200(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.32;
  }

  static double width_200(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.5555555555555556;
  }

  static double height_250(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.4;
  }

  static double width_250(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.6944444444444444;
  }

  // static const double inputSpace = 25.0;
  // // static const double InputToButtonSpace = 50.0;
  // static const double ButtonSpace = 15.0;
  // static const double ContentInternalSpace = 10.0;
  // static const double ContentInternalButtonSpace = 30.0;
  // static const double ImageToInputSpace = 50.0;
//}
  static const LinearGradient gradient = LinearGradient(
    colors: [
      Color(0xff0B4164),
      Color(0xff0476A8),
      Color(0xff009BC0),
      Color(0xff2EB9D3),
    ],
    //Direcionamento do gradient
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static ThemeData getAppTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      useMaterial3: true,
      primaryColor: primaryColor,
      secondaryHeaderColor: secondaryColor,
      primaryColorLight: tertiaryColor,
      primaryColorDark: quarantineColor,
      // Outras configurações de tema, se necessário
    );
  }
}
