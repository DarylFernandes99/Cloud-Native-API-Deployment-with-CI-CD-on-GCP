class MailTemplate:
    def __init__(self) -> None:
        self.template = ""
    
    def default_template(self, verification_link: str, domain_name_updated: str, user_data: dict) -> str:
      #   domain_name_updated = f"http://{domain_name}:8080"
        verification_link_updated = f"{domain_name_updated}{verification_link}"
        return f'''
<html>
   <head>
      <meta charset="utf-8">
      <meta http-equiv="x-ua-compatible" content="ie=edge">
      <title>Email Confirmation</title>
      <meta name="viewport" content="width=device-width, initial-scale=1">
   </head>
   <body style="background-color: #e9ecef;">
      <!-- start preheader -->
      <div class="preheader" style="display: none; max-width: 0; max-height: 0; overflow: hidden; font-size: 1px; line-height: 1px; color: #fff; opacity: 0;">
         Email verification link sent from {domain_name_updated}
      </div>
      <!-- end preheader -->
      <!-- start body -->
      <table border="0" cellpadding="0" cellspacing="0" width="100%">
         <!-- start logo -->
         <tbody>
            <tr>
               <td align="center" bgcolor="#e9ecef">
                  <!--[if (gte mso 9)|(IE)]>
                  <table align="center" border="0" cellpadding="0" cellspacing="0" width="600">
                     <tr>
                        <td align="center" valign="top" width="600">
                           <![endif]-->
                           <table border="0" cellpadding="0" cellspacing="0" width="100%" style="max-width: 600px;">
                              <tbody>
                                 <tr>
                                    <td align="center" valign="top" style="padding: 36px 24px;">
                                       <a href="{domain_name_updated}" target="_blank" style="display: inline-block;">
                                       <img src="https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?q=80&w=1964&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D" alt="Logo" border="0" width="48" style="display: block; width: 48px; max-width: 48px; min-width: 48px; border-radius: 10px">
                                       </a>
                                    </td>
                                 </tr>
                              </tbody>
                           </table>
                           <!--[if (gte mso 9)|(IE)]>
                        </td>
                     </tr>
                  </table>
                  <![endif]-->
               </td>
            </tr>
            <!-- end logo -->
           <tr>
               <td align="center" bgcolor="#e9ecef">
                  <!--[if (gte mso 9)|(IE)]>
                  <table align="center" border="0" cellpadding="0" cellspacing="0" width="600">
                     <tr>
                        <td align="center" valign="top" width="600">
                           <![endif]-->
                           <table border="0" cellpadding="0" cellspacing="0" width="100%" style="max-width: 600px;">
                              <!-- start copy -->
                              <tbody>
                                 <tr>
                                    <td align="left" bgcolor="#ffffff" style="padding: 24px; font-family: 'Source Sans Pro', Helvetica, Arial, sans-serif; font-size: 16px; line-height: 24px;">
                                       <p style="margin: 0;">Hello {user_data["first_name"]} {user_data["last_name"]},</p>
                                    </td>
                                 </tr>
                              </tbody>
                           </table>
                           <!--[if (gte mso 9)|(IE)]>
                        </td>
                     </tr>
                  </table>
                  <![endif]-->
               </td>
            </tr>
            <!-- start hero -->
            <tr>
               <td align="center" bgcolor="#e9ecef">
                  <!--[if (gte mso 9)|(IE)]>
                  <table align="center" border="0" cellpadding="0" cellspacing="0" width="600">
                     <tr>
                        <td align="center" valign="top" width="600">
                           <![endif]-->
                           <table border="0" cellpadding="0" cellspacing="0" width="100%" style="max-width: 600px;">
                              <tbody>
                                 <tr>
                                    <td align="left" bgcolor="#ffffff" style="padding: 36px 24px 0; font-family: 'Source Sans Pro', Helvetica, Arial, sans-serif; border-top: 3px solid #d4dadf;">
                                       <h1 style="margin: 0; font-size: 32px; font-weight: 700; letter-spacing: -1px; line-height: 48px;">Confirm Your Email Address</h1>
                                    </td>
                                 </tr>
                              </tbody>
                           </table>
                           <!--[if (gte mso 9)|(IE)]>
                        </td>
                     </tr>
                  </table>
                  <![endif]-->
               </td>
            </tr>
            <!-- end hero -->
            <!-- start copy block -->
            <tr>
               <td align="center" bgcolor="#e9ecef">
                  <!--[if (gte mso 9)|(IE)]>
                  <table align="center" border="0" cellpadding="0" cellspacing="0" width="600">
                     <tr>
                        <td align="center" valign="top" width="600">
                           <![endif]-->
                           <table border="0" cellpadding="0" cellspacing="0" width="100%" style="max-width: 600px;">
                              <!-- start copy -->
                              <tbody>
                                 <tr>
                                    <td align="left" bgcolor="#ffffff" style="padding: 24px; font-family: 'Source Sans Pro', Helvetica, Arial, sans-serif; font-size: 16px; line-height: 24px;">
                                       <p style="margin: 0;">Tap the button below to confirm your email address. If you didn't create an account with <a href="{domain_name_updated}">Webapp</a>, you can safely delete this email.</p>
                                    </td>
                                 </tr>
                                 <!-- end copy -->
                                 <!-- start button -->
                                 <tr>
                                    <td align="left" bgcolor="#ffffff">
                                       <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                          <tbody>
                                             <tr>
                                                <td align="center" bgcolor="#ffffff" style="padding: 12px;">
                                                   <table border="0" cellpadding="0" cellspacing="0">
                                                      <tbody>
                                                         <tr>
                                                            <td align="center" bgcolor="#1a82e2" style="border-radius: 6px;">
                                                               <a href="{verification_link_updated}" target="_blank" style="display: inline-block; padding: 16px 36px; font-family: 'Source Sans Pro', Helvetica, Arial, sans-serif; font-size: 16px; color: #ffffff; text-decoration: none; border-radius: 6px;">Verify E-mail</a>
                                                            </td>
                                                         </tr>
                                                      </tbody>
                                                   </table>
                                                </td>
                                             </tr>
                                          </tbody>
                                       </table>
                                    </td>
                                 </tr>
                                 <!-- end button -->
                                 <!-- start copy -->
                                 <tr>
                                    <td align="left" bgcolor="#ffffff" style="padding: 24px; font-family: 'Source Sans Pro', Helvetica, Arial, sans-serif; font-size: 16px; line-height: 24px;">
                                       <p style="margin: 0;">If that doesn't work, copy and paste the following link in your browser:</p>
                                       <p style="margin: 0;"><a href="{verification_link_updated}" target="_blank">{verification_link_updated}</a></p>
                                    </td>
                                 </tr>
                                 <!-- end copy -->
                                 <!-- start copy -->
                                 <tr>
                                    <td align="left" bgcolor="#ffffff" style="padding: 24px; font-family: 'Source Sans Pro', Helvetica, Arial, sans-serif; font-size: 16px; line-height: 24px; border-bottom: 3px solid #d4dadf">
                                       <p style="margin: 0;">Cheers,<br> Daryl Fernandes</p>
                                    </td>
                                 </tr>
                                 <!-- end copy -->
                              </tbody>
                           </table>
                           <!--[if (gte mso 9)|(IE)]>
                        </td>
                     </tr>
                  </table>
                  <![endif]-->
               </td>
            </tr>
            <!-- end copy block -->
            <!-- start footer -->
            <tr>
               <td align="center" bgcolor="#e9ecef" style="padding: 24px;">
                  <!--[if (gte mso 9)|(IE)]>
                  <table align="center" border="0" cellpadding="0" cellspacing="0" width="600">
                     <tr>
                        <td align="center" valign="top" width="600">
                           <![endif]-->
                           <table border="0" cellpadding="0" cellspacing="0" width="100%" style="max-width: 600px;">
                              <!-- start permission -->
                              <tbody>
                                 <tr>
                                    <td align="center" bgcolor="#e9ecef" style="padding: 12px 24px; font-family: 'Source Sans Pro', Helvetica, Arial, sans-serif; font-size: 14px; line-height: 20px; color: #666;">
                                       <p style="margin: 0;">You received this email because we received a request to verify your account. If you didn't create an account with <a href="{domain_name_updated}">Webapp</a> you can safely delete this email.</p>
                                    </td>
                                 </tr>
                                 <!-- end permission -->
                                 <!-- start unsubscribe -->
                                 <tr>
                                    <td align="center" bgcolor="#e9ecef" style="padding: 12px 24px; font-family: 'Source Sans Pro', Helvetica, Arial, sans-serif; font-size: 14px; line-height: 20px; color: #666;">
                                       <p style="margin: 0;">To stop receiving these emails, you can <a href="{domain_name_updated}" target="_blank">unsubscribe</a> at any time.</p>
                                       <p style="margin: 0;">360 Huntington Ave, Boston, MA 02115</p>
                                    </td>
                                 </tr>
                                 <!-- end unsubscribe -->
                              </tbody>
                           </table>
                           <!--[if (gte mso 9)|(IE)]>
                        </td>
                     </tr>
                  </table>
                  <![endif]-->
               </td>
            </tr>
            <!-- end footer -->
         </tbody>
      </table>
      <!-- end body -->
   </body>
</html>
'''
