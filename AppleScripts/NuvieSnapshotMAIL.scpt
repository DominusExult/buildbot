FasdUAS 1.101.10   ��   ��    k             l      ��  ��   ^X This script needs to be in ~/Library/Application Scripts/com.apple.mail/ that it is useable with newer OS X versions!	In Mail.app set a Rule 	"if all of the following conditions are met:	Any recipient contains nuvie-svn@lists.sourceforge.net	Subject contains [nuvie/nuvie]
	Subject begins with [Nuvie	Run AppleScript NuvieSnapshotsMAIL" 
     � 	 	�   T h i s   s c r i p t   n e e d s   t o   b e   i n   ~ / L i b r a r y / A p p l i c a t i o n   S c r i p t s / c o m . a p p l e . m a i l /   t h a t   i t   i s   u s e a b l e   w i t h   n e w e r   O S   X   v e r s i o n s !  	 I n   M a i l . a p p   s e t   a   R u l e    	 " i f   a l l   o f   t h e   f o l l o w i n g   c o n d i t i o n s   a r e   m e t :  	 A n y   r e c i p i e n t   c o n t a i n s   n u v i e - s v n @ l i s t s . s o u r c e f o r g e . n e t  	 S u b j e c t   c o n t a i n s   [ n u v i e / n u v i e ] 
 	 S u b j e c t   b e g i n s   w i t h   [ N u v i e  	 R u n   A p p l e S c r i p t   N u v i e S n a p s h o t s M A I L "   
   
  
 l     ����  r         m        �   
 N U V I E  o      ���� 0 subj  ��  ��        l     ��  ��    n h For showing the icon in the Dialog, the icon path is set to the Nuvie.app's app folder in /Applications     �   �   F o r   s h o w i n g   t h e   i c o n   i n   t h e   D i a l o g ,   t h e   i c o n   p a t h   i s   s e t   t o   t h e   N u v i e . a p p ' s   a p p   f o l d e r   i n   / A p p l i c a t i o n s      l    ����  r        b        b        b         b     ! " ! l    #���� # I   �� $ %
�� .earsffdralis        afdr $ m    ��
�� afdrapps % �� &��
�� 
rtyp & m    ��
�� 
TEXT��  ��  ��   " o    ���� 0 subj     m     ' ' � ( ( 0 . a p p : C o n t e n t s : R e s o u r c e s :  o    ���� 0 subj    m     ) ) � * * 
 . i c n s  o      ���� 0 	icon_path  ��  ��     +�� + l   � ,���� , O    � - . - k    � / /  0 1 0 I   ������
�� .miscactvnull��� ��� null��  ��   1  2 3 2 l      �� 4 5��   4 � � Now the script asks you whether you want to build a new 
	Snapshot of Nuvie.
	Then it will open a new Terminal and execute nuviesnapshot.sh 
	in ~/code/sh (where I store my scripts)
	    5 � 6 6p   N o w   t h e   s c r i p t   a s k s   y o u   w h e t h e r   y o u   w a n t   t o   b u i l d   a   n e w   
 	 S n a p s h o t   o f   N u v i e . 
 	 T h e n   i t   w i l l   o p e n   a   n e w   T e r m i n a l   a n d   e x e c u t e   n u v i e s n a p s h o t . s h   
 	 i n   ~ / c o d e / s h   ( w h e r e   I   s t o r e   m y   s c r i p t s ) 
 	 3  7 8 7 r     G 9 : 9 I    C�� ; <
�� .sysodlogaskr        TEXT ; b     % = > = b     # ? @ ? m     ! A A � B B 0 N e w   r e v i s i o n ! ! ! 
 
 
 B u i l d   @ o   ! "���� 0 subj   > m   # $ C C � D D    s n a p s h o t ? 
 < �� E F
�� 
btns E J   & * G G  H I H m   & ' J J � K K  C a n c e l I  L�� L m   ' ( M M � N N  O K��   F �� O P
�� 
givu O m   - 0���� n P �� Q R
�� 
disp Q 4   3 9�� S
�� 
alis S o   7 8���� 0 	icon_path   R �� T��
�� 
appr T o   < =���� 0 subj  ��   : o      ���� 0 snapshotdialog   8  U�� U Z   H � V W���� V G   H c X Y X =   H S Z [ Z n   H O \ ] \ 1   K O��
�� 
bhit ] o   H K���� 0 snapshotdialog   [ m   O R ^ ^ � _ _  O K Y =  V _ ` a ` n   V ] b c b 1   Y ]��
�� 
gavu c o   V Y���� 0 snapshotdialog   a m   ] ^��
�� boovtrue W O   f � d e d k   l � f f  g h g I  l q������
�� .miscactvnull��� ��� null��  ��   h  i j i O  r � k l k O  x � m n m I  � ��� o p
�� .prcskprsnull���     ctxt o m   � � q q � r r  t p �� s��
�� 
faal s J   � � t t  u�� u m   � ���
�� eMdsKcmd��  ��   n 4   x ��� v
�� 
prcs v m   |  w w � x x  T e r m i n a l l m   r u y y�                                                                                  sevs  alis    �  Thunderbolt+               ��0	H+   ��System Events.app                                               {�����        ����  	                CoreServices    ��!�      ����     �� ϶   p  =Thunderbolt+:System: Library: CoreServices: System Events.app   $  S y s t e m   E v e n t s . a p p    T h u n d e r b o l t +  -System/Library/CoreServices/System Events.app   / ��   j  z { z I  � ��� |��
�� .sysodelanull��� ��� nmbr | m   � ����� ��   {  }�� } I  � ��� ~ 
�� .coredoscnull��� ��� ctxt ~ b   � � � � � b   � � � � � m   � � � � � � �   c d   ~ / c o d e / s h ;   .   � o   � ����� 0 subj   � m   � � � � � � �  s n a p s h o t . s h  �� ���
�� 
kfil � n   � � � � � 1   � ���
�� 
tcnt � l  � � ����� � 4  � ��� �
�� 
cwin � m   � ����� ��  ��  ��  ��   e m   f i � ��                                                                                      @ alis    l  Thunderbolt+               ��0	H+    Terminal.app                                                    �{���B        ����  	                	Utilities     ��!�      ���"         m  2Thunderbolt+:Applications: Utilities: Terminal.app    T e r m i n a l . a p p    T h u n d e r b o l t +  #Applications/Utilities/Terminal.app   / ��  ��  ��  ��   . m     � ��                                                                                  emal  alis    F  Thunderbolt+               ��0	H+     mMail.app                                                          ���        ����  	                Applications    ��!�      ���       m  #Thunderbolt+:Applications: Mail.app     M a i l . a p p    T h u n d e r b o l t +  Applications/Mail.app   / ��  ��  ��  ��       �� � ���   � ��
�� .aevtoappnull  �   � **** � �� ����� � ���
�� .aevtoappnull  �   � **** � k     � � �  
 � �   � �  +����  ��  ��   �   � + ���������� ' )�� ��� A C�� J M������������������ ^���� � y�� w q�������� � ����������� 0 subj  
�� afdrapps
�� 
rtyp
�� 
TEXT
�� .earsffdralis        afdr�� 0 	icon_path  
�� .miscactvnull��� ��� null
�� 
btns
�� 
givu�� n
�� 
disp
�� 
alis
�� 
appr�� 
�� .sysodlogaskr        TEXT�� 0 snapshotdialog  
�� 
bhit
�� 
gavu
�� 
bool
�� 
prcs
�� 
faal
�� eMdsKcmd
�� .prcskprsnull���     ctxt
�� .sysodelanull��� ��� nmbr
�� 
kfil
�� 
cwin
�� 
tcnt
�� .coredoscnull��� ��� ctxt�� ��E�O���l �%�%�%�%E�O� �*j 
O��%�%���lva a a *a �/a �a  E` O_ a ,a  
 _ a ,e a & Ua  K*j 
Oa  *a a / a  a !a "kvl #UUOkj $Oa %�%a &%a '*a (k/a ),l *UY hU ascr  ��ޭ