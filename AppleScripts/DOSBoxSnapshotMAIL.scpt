FasdUAS 1.101.10   ��   ��    k             l      ��  ��   F@ This script needs to be in ~/Library/Application Scripts/com.apple.mail/ that it is useable with newer OS X versions!	In Mail.app set a Rule 	"if all of the following conditions are met:	Any recipient contains dosbox-cvs-log@lists.sourceforge.net
	Subject begins with [Dosbox	Run AppleScript DOSBoxSnapshotsMAIL" 
     � 	 	�   T h i s   s c r i p t   n e e d s   t o   b e   i n   ~ / L i b r a r y / A p p l i c a t i o n   S c r i p t s / c o m . a p p l e . m a i l /   t h a t   i t   i s   u s e a b l e   w i t h   n e w e r   O S   X   v e r s i o n s !  	 I n   M a i l . a p p   s e t   a   R u l e    	 " i f   a l l   o f   t h e   f o l l o w i n g   c o n d i t i o n s   a r e   m e t :  	 A n y   r e c i p i e n t   c o n t a i n s   d o s b o x - c v s - l o g @ l i s t s . s o u r c e f o r g e . n e t  
 	 S u b j e c t   b e g i n s   w i t h   [ D o s b o x  	 R u n   A p p l e S c r i p t   D O S B o x S n a p s h o t s M A I L "   
   
  
 l     ����  r         m        �    D O S B o x  o      ���� 0 subj  ��  ��        l     ��  ��    o i For showing the icon in the Dialog, the icon path is set to the DOSBox.app's app folder in /Applications     �   �   F o r   s h o w i n g   t h e   i c o n   i n   t h e   D i a l o g ,   t h e   i c o n   p a t h   i s   s e t   t o   t h e   D O S B o x . a p p ' s   a p p   f o l d e r   i n   / A p p l i c a t i o n s      l    ����  r        b        b        b         b     ! " ! l    #���� # c     $ % $ l   	 &���� & I   	�� '��
�� .earsffdralis        afdr ' m    ��
�� afdrapps��  ��  ��   % m   	 
��
�� 
TEXT��  ��   " o    ���� 0 subj     m     ( ( � ) ) 0 . a p p : C o n t e n t s : R e s o u r c e s :  o    ���� 0 subj    m     * * � + + 
 . i c n s  o      ���� 0 	icon_path  ��  ��     , - , l   � .���� . O    � / 0 / k    � 1 1  2 3 2 I   ������
�� .miscactvnull��� ��� null��  ��   3  4 5 4 l      �� 6 7��   6 � � Now the script asks you whether you want to build a new 
	Snapshot of Nuvie.
	Then it will open a new Terminal and execute dosboxsnapshot.sh 
	in ~/code/sh (where I store my scripts)
	    7 � 8 8r   N o w   t h e   s c r i p t   a s k s   y o u   w h e t h e r   y o u   w a n t   t o   b u i l d   a   n e w   
 	 S n a p s h o t   o f   N u v i e . 
 	 T h e n   i t   w i l l   o p e n   a   n e w   T e r m i n a l   a n d   e x e c u t e   d o s b o x s n a p s h o t . s h   
 	 i n   ~ / c o d e / s h   ( w h e r e   I   s t o r e   m y   s c r i p t s ) 
 	 5  9 : 9 r     E ; < ; I    A�� = >
�� .sysodlogaskr        TEXT = b     % ? @ ? b     # A B A m     ! C C � D D 0 N e w   r e v i s i o n ! ! ! 
 	 
 B u i l d   B o   ! "���� 0 subj   @ m   # $ E E � F F    s n a p s h o t ? 
 > �� G H
�� 
btns G J   & * I I  J K J m   & ' L L � M M  C a n c e l K  N�� N m   ' ( O O � P P  O K��   H �� Q R
�� 
givu Q m   + .���� n R �� S T
�� 
disp S 4   1 7�� U
�� 
alis U o   5 6���� 0 	icon_path   T �� V��
�� 
appr V o   : ;���� 0 subj  ��   < o      ���� 0 snapshotdialog   :  W�� W Z   F � X Y���� X G   F a Z [ Z =   F Q \ ] \ n   F M ^ _ ^ 1   I M��
�� 
bhit _ o   F I���� 0 snapshotdialog   ] m   M P ` ` � a a  O K [ =  T ] b c b n   T [ d e d 1   W [��
�� 
gavu e o   T W���� 0 snapshotdialog   c m   [ \��
�� boovtrue Y O   d � f g f k   j � h h  i j i I  j o������
�� .miscactvnull��� ��� null��  ��   j  k l k O  p � m n m O  v � o p o I  � ��� q r
�� .prcskprsnull���     ctxt q m   � � s s � t t  t r �� u��
�� 
faal u J   � � v v  w�� w m   � ���
�� eMdsKcmd��  ��   p 4   v ~�� x
�� 
prcs x m   z } y y � z z  T e r m i n a l n m   p s { {�                                                                                  sevs  alis    �  Thunderbolt+               ��0	H+   ��System Events.app                                               {�����        ����  	                CoreServices    ��!�      ����     �� ϶   p  =Thunderbolt+:System: Library: CoreServices: System Events.app   $  S y s t e m   E v e n t s . a p p    T h u n d e r b o l t +  -System/Library/CoreServices/System Events.app   / ��   l  | } | I  � ��� ~��
�� .sysodelanull��� ��� nmbr ~ m   � ����� ��   }  ��  I  � ��� � �
�� .coredoscnull��� ��� ctxt � b   � � � � � b   � � � � � m   � � � � � � �   c d   ~ / c o d e / s h ;   .   � o   � ����� 0 subj   � m   � � � � � � �  s n a p s h o t . s h � �� ���
�� 
kfil � n   � � � � � 1   � ���
�� 
tcnt � l  � � ����� � 4  � ��� �
�� 
cwin � m   � ����� ��  ��  ��  ��   g m   d g � ��                                                                                      @ alis    l  Thunderbolt+               ��0	H+    Terminal.app                                                    �{���B        ����  	                	Utilities     ��!�      ���"         m  2Thunderbolt+:Applications: Utilities: Terminal.app    T e r m i n a l . a p p    T h u n d e r b o l t +  #Applications/Utilities/Terminal.app   / ��  ��  ��  ��   0 m     � ��                                                                                  emal  alis    F  Thunderbolt+               ��0	H+     mMail.app                                                          ���        ����  	                Applications    ��!�      ���       m  #Thunderbolt+:Applications: Mail.app     M a i l . a p p    T h u n d e r b o l t +  Applications/Mail.app   / ��  ��  ��   -  ��� � l     ��������  ��  ��  ��       �� � ���   � ��
�� .aevtoappnull  �   � **** � �� ����� � ���
�� .aevtoappnull  �   � **** � k     � � �  
 � �   � �  ,����  ��  ��   �   � * �������� ( *�� ��� C E�� L O������������������ `���� � {�� y s�������� � ����������� 0 subj  
�� afdrapps
�� .earsffdralis        afdr
�� 
TEXT�� 0 	icon_path  
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
�� .coredoscnull��� ��� ctxt�� ��E�O�j �&�%�%�%�%E�O� �*j 	O��%�%���lv�a a *a �/a �a  E` O_ a ,a  
 _ a ,e a & Ua  K*j 	Oa  *a a / a a  a !kvl "UUOkj #Oa $�%a %%a &*a 'k/a (,l )UY hUascr  ��ޭ