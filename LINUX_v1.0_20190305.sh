#!/bin/sh
 
LANG=C
export LANG
BUILD_VER=3.5
LAST_UPDATE=2019.03.05

alias ls=ls

HOST_NAME=`hostname`

CREATE_FILE=`hostname`"_before_ini_".txt

echo > $CREATE_FILE 2>&1

echo "INFO_CHKSTART"  >> $CREATE_FILE 2>&1
echo >> $CREATE_FILE 2>&1

echo "##############################################################################"
echo " 		Copyright (c) 2019 AhnLab Co. Ltd. All rights Reserved. "
echo "##############################################################################"
echo " "
echo " "																				>> $CREATE_FILE 2>&1
echo " "
echo " "																				>> $CREATE_FILE 2>&1
echo "######### Starting Linux Vulnerability Scanner $BUILD_VER #########"
echo " "
echo " "																				>> $CREATE_FILE 2>&1
echo " "
echo " "																				>> $CREATE_FILE 2>&1

echo "#########################################################"
echo "o 호스트 명 : $HOST_NAME"
echo "o 진단일시 : `date`"
echo "#########################################################"						

echo " "																				
echo " "																				>> $CREATE_FILE 2>&1
echo " "																				
echo " "																				>> $CREATE_FILE 2>&1
echo " "																				
echo " "																				>> $CREATE_FILE 2>&1


echo "#################################  커널 정보   #################################" >> $CREATE_FILE 2>&1
uname -a >> $CREATE_FILE 2>&1
echo " " >> $CREATE_FILE 2>&1

echo "#################################  IP 정보    ##################################" >> $CREATE_FILE 2>&1
ifconfig -a >> $CREATE_FILE 2>&1
echo " " >> $CREATE_FILE 2>&1

echo "#################################  네트워크 현황 ###############################" >> $CREATE_FILE 2>&1
netstat -an | egrep -i "LISTEN|ESTABLISHED" >> $CREATE_FILE 2>&1
echo " " >> $CREATE_FILE 2>&1

echo "################################## 라우팅 정보 #################################" >> $CREATE_FILE 2>&1
netstat -rn >> $CREATE_FILE 2>&1
echo " " >> $CREATE_FILE 2>&1

echo "################################## 프로세스 현황 ###############################" >> $CREATE_FILE 2>&1
ps -ef >> $CREATE_FILE 2>&1
echo " " >> $CREATE_FILE 2>&1

echo "################################## 사용자 환경 #################################" >> $CREATE_FILE 2>&1
env >> $CREATE_FILE 2>&1
echo " " >> $CREATE_FILE 2>&1
#아파치 관련 변수 셋팅
web='default'
if [ \( `ps -ef | grep apache2 | grep -v grep | wc -l` -ge 1 \) ]; then
	
	web='apache2'
	apache2 -V | egrep "(HTTPD\_ROOT|SERVER\_CONFIG\_FILE)" | awk -F '"' '{print $2}' > webdir.txt
	apache=`cat -n webdir.txt | grep 1 | awk -F ' ' '{print $2}'`/
	conf=$apache`cat -n webdir.txt | grep 2 | awk -F ' ' '{print $2}'`	 
	if [ `cat $conf | wc -l` -eq 0 ]; then
		conf=`cat -n webdir.txt | grep 2 | awk -F ' ' '{print $2}'`
	fi
	docroot=`cat $conf |grep DocumentRoot |grep -v '\#'|awk -F'"' '{print $2}'`
	echo "################################## WEB설정 정보 #################################" >> $CREATE_FILE 2>&1
	cat $conf >> $CREATE_FILE 2>&1
	echo " " >> $CREATE_FILE 2>&1
	rm -rf webdir.txt

fi

if [ \( `ps -ef | grep httpd | grep -v grep | wc -l` -ge 1 \) ]; then 

	web='httpd'
	httpd -V | egrep "(HTTPD\_ROOT|SERVER\_CONFIG\_FILE)" | awk -F '"' '{print $2}' > webdir.txt
	apache=`cat -n webdir.txt | grep 1 | awk -F ' ' '{print $2}'`/
	conf=$apache`cat -n webdir.txt | grep 2 | awk -F ' ' '{print $2}'`
	if [ `cat $conf | wc -l` -eq 0 ]; then
		conf=`cat -n webdir.txt | grep 2 | awk -F ' ' '{print $2}'`
	fi
	docroot=`cat "$conf" |grep DocumentRoot |grep -v '\#'|awk -F'"' '{print $2}'`
	echo "################################## WEB설정 정보 #################################" >> $CREATE_FILE 2>&1
	cat $conf >> $CREATE_FILE 2>&1 
	echo " " >> $CREATE_FILE 2>&1
rm -rf webdir.txt

fi





U_01() {
  echo -n "U_01. root 계정 원격 접속 제한 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_01. root 계정 원격 접속 제한" >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "▶ 진단 기준 : 원격 서비스를 사용하지 않거나, 사용 시 root 직접 접속을 차단한 경우 양호" >> $CREATE_FILE 2>&1
  echo "▶ 시스템 현황" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  echo "① Telnet 프로세스 데몬 동작 확인 " >> $CREATE_FILE 2>&1
  echo "------------------------------------------------------------------------------" >> $CREATE_FILE 2>&1

  if [ `ps -ef | grep -v grep | grep -i "telnet" | wc -l` -gt 0 ]
	  then
          ps -ef | grep -v grep | grep -i "telnet" >> $CREATE_FILE 2>&1
		  echo " " >> $CREATE_FILE 2>&1
    	  echo "☞ Telnet Service enable" >> $CREATE_FILE 2>&1
		  
		  echo " " >> $CREATE_FILE 2>&1
		  echo " " >> $CREATE_FILE 2>&1
  
		  echo "② /etc/securetty 현황" >> $CREATE_FILE 2>&1
	      echo "------------------------------------------------------------------------------" >> $CREATE_FILE 2>&1
		  if [ -f /etc/securetty ]
			then
			  cat /etc/securetty | grep -i "pts" >> $CREATE_FILE 2>&1
			  if [ `cat /etc/securetty | grep -i "pts" | grep -v '#' | wc -l` -eq 0 ]
			    then
				  result_telnet='true'
				else
				  result_telnet='false'
			  fi
			else
			   echo "/etc/securetty파일이 존재하지 않습니다." >> $CREATE_FILE 2>&1
			   result_telnet='false'
		   fi
		   
		   echo " " >> $CREATE_FILE 2>&1
		   
		   echo "ⓢ /etc/pam.d/login 현황" >> $CREATE_FILE 2>&1
	       echo "------------------------------------------------------------------------------" >> $CREATE_FILE 2>&1
		   if [ -f /etc/pam.d/login ]
			then
			  cat /etc/pam.d/login | grep -i "pam_securetty.so" >> $CREATE_FILE 2>&1
			  if [ `cat /etc/pam.d/login | grep "pam_securetty.so" | grep -v "#" | wc -l` -eq 0 ]
			    then
				  result_telnet='false'
				else
				  result_telnet='true'
			  fi
			else
			   echo "/etc/pam.d/login파일이 존재하지 않습니다." >> $CREATE_FILE 2>&1
			   result_telnet='false'
		   fi
   else
      	echo "☞ Telnet Service disable" >> $CREATE_FILE 2>&1
		result_telnet='true'		
  fi
  
  
  echo " " >> $CREATE_FILE 2>&1  
  echo " " >> $CREATE_FILE 2>&1 
  
  
  
  echo "① SSH 프로세스 데몬 동작 확인 " >> $CREATE_FILE 2>&1
  echo "------------------------------------------------------------------------------" >> $CREATE_FILE 2>&1

  if [ `ps -ef | grep sshd | grep -v "grep" | wc -l` -eq 0 ]
	  then
		  echo "☞ SSH Service Disable" >> $CREATE_FILE 2>&1
		  result_sshd='true'
	  else
		  ps -ef | grep sshd | grep -v "grep" >> $CREATE_FILE 2>&1
		  echo " " >> $CREATE_FILE 2>&1 
		  echo "☞ SSH Service Enable" >> $CREATE_FILE 2>&1
		  
		  echo " " >> $CREATE_FILE 2>&1 
		  echo " " >> $CREATE_FILE 2>&1 
		  
		  echo "② sshd_config파일 확인" >> $CREATE_FILE 2>&1
		  echo "------------------------------------------------------------------------------" >> $CREATE_FILE 2>&1

		  echo " " > ssh-result.ahnlab

		  ServiceDIR="/etc/sshd_config /etc/ssh/sshd_config /usr/local/etc/sshd_config /usr/local/sshd/etc/sshd_config /usr/local/ssh/etc/sshd_config /etc/opt/ssh/sshd_config"

		  for file in $ServiceDIR
			do
				if [ -f $file ]
					then
						if [ `cat $file | grep "PermitRootLogin" | grep -v "setting" | wc -l` -gt 0 ]
							then
							cat $file | grep "PermitRootLogin" | grep -v "setting" | awk '{print "SSH 설정파일('${file}'): "}' >> ssh-result.ahnlab
							echo " " >> $CREATE_FILE 2>&1
							cat $file | grep "PermitRootLogin" | grep -v "setting" | awk '{print $0 }' >> ssh-result.ahnlab 
							if [ `cat $file | grep -i "PermitRootLogin no" | grep -v '#' | wc -l` -gt 0 ]
								then
									result_sshd='true'
								else
									result_sshd='false'
							fi
						else	
							echo "SSH 설정파일($file): PermitRootLogin 설정이 존재하지 않습니다." >> ssh-result.ahnlab
						fi
						if [ `cat $file | grep -i "banner" | grep -v "default banner" | wc -l` -gt 0 ]
							then
								cat $file | grep -i "banner" | grep -v "default banner" | awk '{print "SSH 설정파일('${file}'): " $0 }' >> ssh-banner.ahnlab
						else
							echo "ssh 로그인 전 출력되는 배너지정이 되어 있지 않습니다. " >> ssh-banner.ahnlab
						fi	
						# U_67 항목 ssh 배너설정 여부 추가, ssh-banner.ahnlab 파일 해당 항목에서 제거
				fi
			done 
			
			  if [ `cat ssh-result.ahnlab | grep -v "^ *$" | wc -l` -gt 0 ]
				then
					cat ssh-result.ahnlab | grep -v "^ *$" >> $CREATE_FILE 2>&1
			  else
				echo "SSH 설정파일을 찾을 수 없습니다. (인터뷰/수동점검)" >> $CREATE_FILE 2>&1
			  fi
			
	fi

  echo " " >> $CREATE_FILE 2>&1 
  echo " " >> $CREATE_FILE 2>&1 
  
  if [ $result_telnet = 'true' -a $result_sshd = 'true' ]
    then
      echo "★ U_01. 결과 : 양호" >> $CREATE_FILE 2>&1
    else
      echo "★ U_01. 결과 : 취약" >> $CREATE_FILE 2>&1
  fi
  

  rm -rf ssh-result.ahnlab

  
  result="완료"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_02() {
  echo -n "U_02. 패스워드 복잡성 설정 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_02. 패스워드 복잡성 설정" >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "▶ 점검기준 : 영문·숫자·특수문자가 혼합된 9자리 이상의 패스워드가 설정된 경우 양호" >> $CREATE_FILE 2>&1
  echo "▶ 시스템 현황" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  
  if [ -f /etc/shadow ]
    then
      echo "[/etc/shadow 파일 설정 현황]" >> $CREATE_FILE 2>&1
      cat /etc/shadow  | grep -v '*' | grep -v '!' | grep -v '!!' >> $CREATE_FILE 2>&1
    else
      echo "/etc/shadow 파일이 없습니다. " >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1
  echo "★ U_02. 결과 : 수동점검" >> $CREATE_FILE 2>&1

  result="완료"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_03() {
  echo -n "U_03. 계정 잠금 임계값 설정 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_03. 계정 잠금 임계값 설정" >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "▶ 점검기준 : 계정 잠금 임계값이 5이하의 값으로 설정되어 있는 경우 양호" >> $CREATE_FILE 2>&1
  echo "▶ 시스템 현황" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  
  if [ -f /etc/pam.d/system-auth ]; then
	if [ `cat /etc/pam.d/system-auth | grep -i "pam_tally.so" | grep -v "#" | wc -l` -gt 0 ]  #20160105-01 start
		then
			cat /etc/pam.d/system-auth | grep -i "pam_tally.so" | grep -v "#" >> $CREATE_FILE 2>&1
	else if [ `cat /etc/pam.d/system-auth | grep -i "pam_tally2.so" | grep -v "#" | wc -l` -gt 0 ]
		then
			cat /etc/pam.d/system-auth | grep -i "pam_tally2.so" | grep -v "#" >> $CREATE_FILE 2>&1
	else
		echo "/etc/pam.d/system-auth 파일에 설정값이 없습니다." >> $CREATE_FILE 2>&1
	fi
	fi
    else
	    echo "/etc/pam.d/system-auth 파일이 존재하지 않습니다." >> $CREATE_FILE 2>&1
  fi	
  echo " " >> $CREATE_FILE 2>&1


  if [ -f /etc/pam.d/system-auth ]
	then
		if [ `grep "pam_tally.so" /etc/pam.d/system-auth | grep -v '#' | wc -l` -gt 0 ]
			then
				if [ `cat /etc/pam.d/system-auth | grep -v '#' |grep -i "deny=" | awk -F'deny=' '{print $2}'|awk '{print $1}'` -le 5 ]
					then
						echo "★ U_03. 결과 : 양호" >> $CREATE_FILE 2>&1
				else
						echo "★ U_03. 결과 : 취약" >> $CREATE_FILE 2>&1
				fi
		else if [ `grep "pam_tally2.so" /etc/pam.d/system-auth | grep -v '#' | wc -l` -gt 0  ] 
			then
				if [ `cat /etc/pam.d/system-auth | grep -v '#' |grep -i "deny=" | awk -F'deny=' '{print $2}'|awk '{print $1}'` -le 5 ]
					then
						echo "★ U_03. 결과 : 양호" >> $CREATE_FILE 2>&1
				else
						echo "★ U_03. 결과 : 취약" >> $CREATE_FILE 2>&1
				fi
		else
			echo "★ U_03. 결과 : 취약" >> $CREATE_FILE 2>&1
		fi
		fi
	else
		echo "★ U_03. 결과 : 취약" >> $CREATE_FILE 2>&1
	fi
 #20160105-01 end

  result="완료"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_04() {
  echo -n "U_04. 패스워드 파일 보호 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_04 패스워드 파일 보호" >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "▶ 점검기준 : 쉐도우 패스워드를 사용하거나, 패스워드를 암호화하여 저장하는 경우 양호" >> $CREATE_FILE 2>&1
  echo "▶ 시스템 현황" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  if [ -f /etc/shadow ]
    then
	  echo "[/etc/shadow 파일 설정 현황]" >> $CREATE_FILE 2>&1
      cat /etc/shadow | grep -v '!'  | grep -v '!!' | grep -v '*'  >> $CREATE_FILE 2>&1
    else
      echo "/etc/shadow 파일이 존재하지 않습니다." >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1


  if [ -f /etc/shadow ]
    then
      echo "★ U_04. 결과 : 양호" >> $CREATE_FILE 2>&1
    else
      echo "★ U_04. 결과 : 취약" >> $CREATE_FILE 2>&1
  fi


  result="완료"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_05() {
  echo -n "U_05. root 이외의 UID '0' 금지 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_05. root 이외의 UID '0' 금지" >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "▶ 점검기준 : root 계정과 동일한 UID를 갖는 계정이 존재하지 않는 경우 양호" >> $CREATE_FILE 2>&1
  echo "▶ 시스템 현황" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  if [ -f /etc/passwd ]
    then
      awk -F: '$3==0 { print $1 " -> UID=" $3 }' /etc/passwd >> $CREATE_FILE 2>&1
    else
      echo "/etc/passwd 파일이 없습니다." >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1

  echo "[/etc/passwd 파일 내용]" >> $CREATE_FILE 2>&1
  cat /etc/passwd >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  if [ `awk -F: '$3==0  { print $1 }' /etc/passwd | grep -v "root" | wc -l` -eq 0 ]
    then
      echo "★ U_05. 결과 : 양호" >> $CREATE_FILE 2>&1
    else
      echo "★ U_05. 결과 : 취약" >> $CREATE_FILE 2>&1
  fi


  result="완료"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_06() {
  echo -n "U_06. root계정 su 제한 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_06. root계정 su 제한" >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "▶ 점검기준 : su 명령어를 특정 그룹에 속한 사용자만 사용하도록 제한되어 있는 경우 양호" >> $CREATE_FILE 2>&1
  echo "              pam 설정 없더라도 su파일 퍼미션(4750)과 별도 사용그룹이 설정 되어있는경우 양호" >> $CREATE_FILE 2>&1
  echo "▶ 시스템 현황" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  echo "① /etc/pam.d/su 파일 내 pam_wheel.so 설정" >> $CREATE_FILE 2>&1
  echo "------------------------------------------------------------------------------" >> $CREATE_FILE 2>&1
  if [ -f /etc/pam.d/su ]
    then
      if [ `cat /etc/pam.d/su | grep -i "pam_wheel.so" | grep -v '#' | grep -v 'trust' | wc -l` -eq 1 ]
      then
        cat /etc/pam.d/su | grep -i "pam_wheel.so" | grep -v '#' | grep -v 'trust' >> $CREATE_FILE 2>&1
        echo " " >> $CREATE_FILE 2>&1
        echo "☞ pam 설정 되어있음" >> $CREATE_FILE 2>&1
      else
        echo "☞ pam 설정 되어있지 않음" >> $CREATE_FILE 2>&1
      fi
  else
     echo "/etc/pam.d/su 파일이 없습니다. " >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  echo "② su 파일 퍼미션(기반시설 기준 /usr/bin/su) " >> $CREATE_FILE 2>&1
  echo "------------------------------------------------------------------------------" >> $CREATE_FILE 2>&1
  if [ -f /usr/bin/su ]
   then
     ls -al /usr/bin/su >> $CREATE_FILE 2>&1
   else
     echo "/usr/bin/su 파일이 없습니다. " >> $CREATE_FILE 2>&1 
  fi
  echo " " >> $CREATE_FILE 2>&1
  if [ -f /bin/su ]
   then
  	 ls -al /bin/su >> $CREATE_FILE 2>&1
   else
     echo "/bin/su 파일이 존재하지 않습니다." >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  echo "③ /etc/group 파일 내역(wheel 또는 su 제한 그룹 포함계정 리스트 확인)" >> $CREATE_FILE 2>&1
  echo "------------------------------------------------------------------------------" >> $CREATE_FILE 2>&1
  cat /etc/group >> $CREATE_FILE 2>&1

  echo " " >> $CREATE_FILE 2>&1

  if [ `cat /etc/pam.d/su | grep 'pam_wheel.so' | grep -v '#' | grep -v 'trust' | wc -l` -eq 0 ]
    then
      if [ -f /bin/su ]
        then
          if [ `ls -alL /bin/su | grep ".....-.---" | wc -l` -eq 1 ]
            then
              echo "★ U_06. 결과 : 양호" >> $CREATE_FILE 2>&1
            else
              echo "★ U_06. 결과 : 취약" >> $CREATE_FILE 2>&1
          fi
      elif [ -f /usr/bin/su ]
       then
         if [ `ls -alL usr/bin/su | grep ".....-.---" | wc -l` -eq 1 ]
            then
              echo "★ U_06. 결과 : 양호" >> $CREATE_FILE 2>&1
            else
              echo "★ U_06. 결과 : 취약" >> $CREATE_FILE 2>&1
         fi
          echo "★ U_06. 결과 : 취약" >> $CREATE_FILE 2>&1
      fi
    else
      echo "★ U_06. 결과 : 양호" >> $CREATE_FILE 2>&1
  fi


  result="완료"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_07() {
  echo -n "U_07. 패스워드 최소 길이 설정 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_07. 패스워드 최소 길이 설정" >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "▶ 점검기준 : 패스워드 최소 길이가 9자 이상으로 설정되어 있는 경우 양호(국정원 기준 9자리)" >> $CREATE_FILE 2>&1
  echo "▶ 시스템 현황" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  if [ -f /etc/login.defs ]
    then
      echo "[패스워드 설정 현황]" >> $CREATE_FILE 2>&1
      cat /etc/login.defs | grep -i "PASS_MIN_LEN" | grep -v "#" >> $CREATE_FILE 2>&1
    else
      echo " /etc/login.defs 파일이 존재하지 않음 " >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1
  echo " " > password.ahnlab
  
  if [ -f /etc/login.defs ]
  then
  if [ `cat /etc/login.defs | grep -i "PASS_MIN_LEN" | grep -v "#" | awk '{print $2}'` -gt 8 ]
    then
      echo "양호" >> password.ahnlab 2>&1
    else
      echo "취약" >> password.ahnlab 2>&1
  fi
  fi


  if [ `cat password.ahnlab | grep "취약" | wc -l` -eq 0 ]
    then
	  echo "★ U_07. 결과 : 양호" >> $CREATE_FILE 2>&1
    else
      echo "★ U_07. 결과 : 취약" >> $CREATE_FILE 2>&1
  fi

  rm -rf password.ahnlab


  result="완료"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_08() {
  echo -n "U_08. 패스워드 최대 사용기간 설정 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_08. 패스워드 최대 사용기간 설정" >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "▶ 점검기준 : 패스워드 최대 사용기간이 90일(12주) 이하로 설정되어 있을 경우 양호" >> $CREATE_FILE 2>&1
  echo "▶ 시스템 현황" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  if [ -f /etc/login.defs ]
    then
      echo "[패스워드 설정 현황]" >> $CREATE_FILE 2>&1
      cat /etc/login.defs | grep -i "PASS_MAX_DAYS" | grep -v "#" >> $CREATE_FILE 2>&1
    else
      echo " /etc/login.defs 파일이 존재하지 않음 " >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1
  echo " " > password.ahnlab
  
  if [ `cat /etc/login.defs | grep -i "PASS_MAX_DAYS" | grep -v "#" | awk '{print $2}'` -le 90 ]
    then
      echo "양호" >> password.ahnlab 2>&1
    else
      echo "취약" >> password.ahnlab 2>&1
  fi


  if [ `cat password.ahnlab | grep "취약" | wc -l` -eq 0 ]
    then
      echo "★ U_08. 결과 : 양호" >> $CREATE_FILE 2>&1
    else
      echo "★ U_08. 결과 : 취약" >> $CREATE_FILE 2>&1
  fi

  rm -rf password.ahnlab


  result="완료"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_09() {
  echo -n "U_09. 패스워드 최소 사용기간 설정 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_09. 패스워드 최소 사용기간 설정" >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "▶ 점검기준 : 패스워드 최소 사용기간이 1일(1주)로 설정되어 있는 경우 양호" >> $CREATE_FILE 2>&1
  echo "▶ 시스템 현황" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  if [ -f /etc/login.defs ]
    then
      echo "[패스워드 설정 현황]" >> $CREATE_FILE 2>&1
      cat /etc/login.defs | grep -i "PASS_MIN_DAYS" | grep -v "#" >> $CREATE_FILE 2>&1
    else
      echo " /etc/login.defs 파일이 존재하지 않음 " >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1
  echo " " > password.ahnlab
  
  if [ `cat /etc/login.defs | grep -i "PASS_MIN_DAYS" | grep -v "#" | awk '{print $2}'` -ge 1 ]
    then
      echo "양호" >> password.ahnlab 2>&1
    else
      echo "취약" >> password.ahnlab 2>&1
  fi


  if [ `cat password.ahnlab | grep "취약" | wc -l` -eq 0 ]
    then
      echo "★ U_09. 결과 : 양호" >> $CREATE_FILE 2>&1
    else
      echo "★ U_09. 결과 : 취약" >> $CREATE_FILE 2>&1
  fi

  rm -rf password.ahnlab


  result="완료"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_10() {
  echo -n "U_10. 불필요한 계정 제거 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_10. 불필요한 계정 제거" >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "▶ 점검기준 : 불필요한 계정이 존재하지 않는 경우 양호" >> $CREATE_FILE 2>&1
  echo "              기본 설치되는 시스템 계정 중 불필요한 계정 확인" >> $CREATE_FILE 2>&1
  echo "              오랫동안 로그인 기록이 없는 사용자 계정 확인" >> $CREATE_FILE 2>&1
  echo "▶ 시스템 현황" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  
  echo "① 기본 시스템 계정(adm, lp, sync, shutdown, halt, news, uucp, nuucp, operator, games, gopher, nfsnobody, squid) " >> $CREATE_FILE 2>&1
  echo "------------------------------------------------------------------------------" >> $CREATE_FILE 2>&1
  if [ `cat /etc/passwd | egrep "^adm:|^lp:| ^sync: | ^shutdown:| ^halt:|^news:|^uucp:|^nuucp:|^operator:|^games:|^gopher:|^nfsnobody:|^squid:" | wc -l` -eq 0 ]
    then
      echo "불필요한 기본 시스템 계정이 존재하지 않습니다." >> $CREATE_FILE 2>&1
    else
      cat /etc/passwd | egrep "^adm:|^lp:| ^sync: | ^shutdown:| ^halt:|^news:|^uucp:|^nuucp:|^operator:|^games:|^gopher:|^nfsnobody:|^squid:" >> $CREATE_FILE 2>&1
  fi
  echo " " >> $CREATE_FILE 2>&1
  
  echo "② 계정 접속 로그(lastlog) " >> $CREATE_FILE 2>&1
  echo "------------------------------------------------------------------------------" >> $CREATE_FILE 2>&1
  lastlog >> $CREATE_FILE 2>&1

  echo " " >> $CREATE_FILE 2>&1
  echo "★ U_10. 결과 : 수동점검" >> $CREATE_FILE 2>&1
  


  result="완료"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_11() {
  echo -n "U_11. 관리자 그룹에 최소한의 계정 포함 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_11. 관리자 그룹에 최소한의 계정 포함" >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "▶ 점검기준 : 관리자 그룹에 불필요한 계정이 등록되어 있지 않은 경우 양호(계정이 여러개 있을경우 담당자 확인 필요)" >> $CREATE_FILE 2>&1
  echo "▶ 시스템 현황" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  if [ -f /etc/group ]
    then
      echo "[관리자 그룹 계정 현황]" >> $CREATE_FILE 2>&1
      cat /etc/group | grep "root:" >> $CREATE_FILE 2>&1
    else
      echo " /etc/group 파일이 없습니다." >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1

  if [ `cat /etc/group | grep "root:" | grep ":root," | wc -l` -eq 0 ]
    then
      echo "★ U_11. 결과 : 양호" >> $CREATE_FILE 2>&1
    else
      echo "★ U_11. 결과 : 취약" >> $CREATE_FILE 2>&1
  fi


  result="완료"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_12() {
  echo -n "U_12. 계정이 존재하지 않는 GID 금지 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_12. 계정이 존재하지 않는 GID 금지" >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "▶ 점검기준 : 존재하지 않는 계정에 GID 설정을 금지한 경우 양호(기본 시스템 계정 외 신규 생성된 계정만 확인)" >> $CREATE_FILE 2>&1
  echo "▶ 시스템 현황" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  
  echo "☞ 구성원이 존재하지 않는 그룹" >> $CREATE_FILE 2>&1 #20160106-03
  echo "------------------------------------------------------------------------------" >> $CREATE_FILE 2>&1
  awk -F: '{print $3}' /etc/group > gid_group.txt 
  
  for D in `cat gid_group.txt` 
  do 
	awk -F: '{print $4}' /etc/passwd | grep -w $D > gid_1.txt 
	
	if [ `cat gid_1.txt | wc -l` -gt 0 ]
	then 
		echo "gid=$D"  > /dev/null 
	else 
		echo $D >> gid_none.txt 
	fi 
 done

	if [ `cat gid_none.txt | wc -l` -gt 0 ]
	then
		for A in `cat gid_none.txt` 
		do
			awk -F: '{print $1, $3}' /etc/group | grep -w $A >> $CREATE_FILE 2>&1  
			done 
		echo " " >> $CREATE_FILE 2>&1
		echo "★ U_12. 결과 : 취약" >> $CREATE_FILE 2>&1 
	else
	    echo " " >> $CREATE_FILE 2>&1
		echo "★ U_12. 결과 : 양호" >> $CREATE_FILE 2>&1
	fi
  
rm -rf gid_group.txt 
rm -rf gid_none.txt 
rm -rf gid_1.txt   

  result="완료"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_13() {
  echo -n "U_13. 동일한 UID 금지 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_13. 동일한 UID 금지" >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "▶ 점검기준 : 동일한 UID로 설정된 사용자 계정이 존재하지 않는 경우 양호" >> $CREATE_FILE 2>&1
  echo "▶ 시스템 현황" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  for uid in `cat /etc/passwd | awk -F: '{print $3}'`
    do
	    cat /etc/passwd | awk -F: '$3=="'${uid}'" { print "UID=" $3 " -> " $1 }' > account.ahnlab
    	if [ `cat account.ahnlab | wc -l` -gt 1 ]
	      then
		      cat account.ahnlab >> total-account.ahnlab
	    fi
    done
if [ -f total-account.ahnlab ]
	then
  if [ `sort -k 1 total-account.ahnlab | wc -l` -gt 1 ]
    then
	    sort -k 1 total-account.ahnlab | uniq -d >> $CREATE_FILE 2>&1
	fi
else
	    echo "동일한 UID를 사용하는 계정이 발견되지 않았습니다." >> $CREATE_FILE 2>&1
  
fi
  echo " " >> $CREATE_FILE 2>&1

if [ -f total-account.ahnlab ]
	then
  if [ `sort -k 1 total-account.ahnlab | wc -l` -gt 1 ]
    then
      echo "★ U_13. 결과 : 취약" >> $CREATE_FILE 2>&1
	fi
else
      echo "★ U_13. 결과 : 양호" >> $CREATE_FILE 2>&1 
fi
  rm -rf account.ahnlab
  rm -rf total-account.ahnlab

  result="완료"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_14() {
  echo -n "U_14. 사용자 shell 점검 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_14. 사용자 shell 점검" >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "▶ 점검기준 : 로그인이 필요하지 않은 계정에 /bin/false(nologin) 쉘이 부여되어 있는 경우 양호" >> $CREATE_FILE 2>&1
  echo "▶ 시스템 현황" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  if [ -f /etc/passwd ]
    then
      cat /etc/passwd | egrep "^daemon|^bin|^sys|^adm|^listen|^nobody|^nobody4|^noaccess|^diag|^listen|^operator|^games|^gopher" | grep -v "admin" >> $CREATE_FILE 2>&1
    else
      echo "/etc/passwd 파일이 없습니다." >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1

  if [ `cat /etc/passwd | egrep "^daemon|^bin|^sys|^adm|^listen|^nobody|^nobody4|^noaccess|^diag|^listen|^operator|^games|^gopher" | grep -v "admin" |  awk -F: '{print $7}'| egrep -v 'false|nologin|null|halt|sync|shutdown' | wc -l` -eq 0 ]
    then
      echo "★ U_14. 결과 : 양호" >> $CREATE_FILE 2>&1
    else
      echo "★ U_14. 결과 : 취약" >> $CREATE_FILE 2>&1
  fi


  result="완료"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_15() {
  echo -n "U_15. Session Timeout 설정 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_15. Session Timeout 설정" >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "▶ 점검기준 : Session Timeout이 600초(10분) 이하로 설정되어 있는 경우 양호" >> $CREATE_FILE 2>&1
  echo "▶ 시스템 현황" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1


  echo "" > account_sson.ahnlab
  
  echo "① /etc/profile 파일설정" >> $CREATE_FILE 2>&1
  echo "------------------------------------------------------------------------------" >> $CREATE_FILE 2>&1	

  if [ -f /etc/profile ]
    then
	  if [ `cat /etc/profile | egrep -i "TMOUT|TIMEOUT" | grep -v "#" | wc -l` -eq 0 ]
	   then
	     echo "/etc/profile 파일 내 TMOUT/TIMEOUT 설정이 없습니다." >> $CREATE_FILE 2>&1
		 echo "취약" >> account_sson.ahnlab
       else
	     cat /etc/profile | egrep -i "TMOUT|TIMEOUT" >> $CREATE_FILE 2>&1
		 if [ `cat /etc/profile | grep -v "#" | egrep -i "TMOUT|TIMEOUT" | grep -v '[0-9]600' | grep '600$' | wc -l ` -eq 0 ]
		   then
		     echo "취약" >> account_sson.ahnlab
	       else
		     echo "양호" >> account_sson.ahnlab
	     fi
	  fi
    else
      echo "/etc/profile 파일이 없습니다." >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1

  
  if [ -f /etc/csh.login ]
    then
	 echo "② /etc/csh.login 파일설정" >> $CREATE_FILE 2>&1
     echo "------------------------------------------------------------------------------" >> $CREATE_FILE 2>&1	
	  if [ `cat /etc/csh.login | egrep -i "autologout" | grep -v "#" | wc -l` -eq 0 ]
	   then
	    echo "/etc/csh.login 파일 내 autologout 설정이 없습니다." >> $CREATE_FILE 2>&1
		echo "취약" >> account_sson.ahnlab
	  else
       cat /etc/csh.login | grep -i "autologout" >> $CREATE_FILE 2>&1
	   	if [ `cat /etc/csh.login | grep -v "#" | grep -i 'autologout' | grep -v '[0-9]10' | grep '10$' | wc -l ` -eq 0 ]
		   then
		     echo "취약" >> account_sson.ahnlab
	       else
		     echo "양호" >> account_sson.ahnlab
	    fi
	  fi
  else if [ -f /etc/csh.cshrc ]
   then
    echo "② /etc/csh.cshrc 파일설정" >> $CREATE_FILE 2>&1
    echo "------------------------------------------------------------------------------" >> $CREATE_FILE 2>&1	
      if [ `cat /etc/csh.cshrc | egrep -i "autologout" | grep -v "#" | wc -l` -eq 0 ]
	   then
	    echo "/etc/csh.cshrc 파일 내 autologout 설정이 없습니다." >> $CREATE_FILE 2>&1
		echo "취약" >> account_sson.ahnlab
	  else
       cat /etc/csh.cshrc | grep -i "autologout" >> $CREATE_FILE 2>&1
	   	if [ `cat /etc/csh.cshrc | grep -v "#" | grep -i 'autologout' | grep -v '[0-9]10' | grep '10$' | wc -l ` -eq 0 ]
		   then
		     echo "취약" >> account_sson.ahnlab
	       else
		     echo "양호" >> account_sson.ahnlab
	    fi
	  fi
  else
     echo "/etc/csh.login, /etc/csh.cshrc 파일이 없습니다." >> $CREATE_FILE 2>&1
  fi
  fi

  echo " " >> $CREATE_FILE 2>&1

  if [ `cat account_sson.ahnlab | grep "취약" | wc -l` -eq 0 ]
    then
       echo "★ U_15. 결과 : 양호" >> $CREATE_FILE 2>&1
    else
       echo "★ U_15. 결과 : 취약" >> $CREATE_FILE 2>&1
  fi
  
  rm -rf account_sson.ahnlab


  result="완료"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_16() {
  echo -n "U_16. root 홈, 패스 디렉터리 권한 및 패스 설정 >>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_16. root 홈, 패스 디렉터리 권한 및 패스 설정" >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "▶ 점검기준 : PATH 환경변수에 '.' 이 맨 앞이나 중간에 포함되지 않은 경우 양호" >> $CREATE_FILE 2>&1
  echo "▶ 시스템 현황" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  echo " " >> $CREATE_FILE 2>&1
  echo "① PATH 환경변수 현황" >> $CREATE_FILE 2>&1
  echo "------------------------------------------------------------------------------" >> $CREATE_FILE 2>&1	  
  echo $PATH >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  echo " " >> $CREATE_FILE 2>&1

  if [ `echo $PATH | grep "\.:" | wc -l` -eq 0 ]
    then
      echo "★ U_16. 결과 : 양호" >> $CREATE_FILE 2>&1
    else
      echo "★ U_16. 결과 : 취약" >> $CREATE_FILE 2>&1
  fi


  result="완료"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_17() {
  echo -n "U_17. 파일 및 디렉터리 소유자 설정 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_17. 파일 및 디렉터리 소유자 설정" >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "▶ 점검기준 : 소유자가 존재하지 않은 파일 및 디렉터리가 존재하지 않은 경우 양호" >> $CREATE_FILE 2>&1
  echo "▶ 시스템 현황" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  echo "① 소유자가 존재하지 않는 파일" >> $CREATE_FILE 2>&1
  echo "------------------------------------------------------------------------------" >> $CREATE_FILE 2>&1
  for i in /home /usr /tmp
  do
    find $i -nouser >> file-own.ahnlab
  done
  
  if [ -s file-own.ahnlab ]
    then
	    cat file-own.ahnlab >> $CREATE_FILE 2>&1
    else
	    echo "소유자가 존재하지 않는 파일이 발견되지 않았습니다." >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1
  
  if [ -s file-own.ahnlab ]
    then
      echo "★ U_17. 결과 : 취약" >> $CREATE_FILE 2>&1
    else
      echo "★ U_17. 결과 : 양호" >> $CREATE_FILE 2>&1
  fi

  rm -rf file-own.ahnlab

  result="완료"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_18() {
  echo -n "U_18. /etc/passwd 파일 소유자 및 권한 설정 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_18. /etc/passwd 파일 소유자 및 권한 설정" >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "▶ 점검기준 : /etc/passwd 파일의 소유자가 root이고, 권한이 644 이하인 경우 양호" >> $CREATE_FILE 2>&1
  echo "▶ 시스템 현황" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  if [ -f /etc/passwd ]
    then
	  echo "① /etc/passwd 파일 퍼미션 확인" >> $CREATE_FILE 2>&1
      echo "------------------------------------------------------------------------------" >> $CREATE_FILE 2>&1
      ls -alL /etc/passwd >> $CREATE_FILE 2>&1
    else
      echo " /etc/passwd 파일이 없습니다." >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1


  if [ `ls -alL /etc/passwd | grep "...-.--.--" | wc -l` -eq 1 ]
    then
      echo "★ U_18. 결과 : 양호" >> $CREATE_FILE 2>&1
    else
      echo "★ U_18. 결과 : 취약" >> $CREATE_FILE 2>&1
  fi


  result="완료"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_19() {
  echo -n "U_19. /etc/shadow 파일 소유자 및 권한 설정 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_19. /etc/shadow 파일 소유자 및 권한 설정 " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "▶ 점검기준 : /etc/shadow 파일의 소유자가 root이고, 권한이 400 이하인 경우 양호" >> $CREATE_FILE 2>&1
  echo "▶ 시스템 현황" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1


  if [ -f /etc/shadow ]
    then
      echo "① /etc/shadow 파일 퍼미션 확인" >> $CREATE_FILE 2>&1
      echo "------------------------------------------------------------------------------" >> $CREATE_FILE 2>&1
	  ls -alL /etc/shadow >> $CREATE_FILE 2>&1
    else
      echo " /etc/shadow 파일이 없습니다." >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1


  if [ `ls -alL /etc/shadow | grep "..--------" | wc -l` -eq 1 ]
    then
      echo "★ U_19. 결과 : 양호" >> $CREATE_FILE 2>&1
    else
      echo "★ U_19. 결과 : 취약" >> $CREATE_FILE 2>&1
  fi


  result="완료"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_20() {
  echo -n "U_20. /etc/hosts 파일 소유자 및 권한 설정 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_20. /etc/hosts 파일 소유자 및 권한 설정 " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "▶ 점검기준 : /etc/hosts 파일의 소유자가 root이고, 권한이 600 이하인 경우 양호" >> $CREATE_FILE 2>&1
  echo "▶ 시스템 현황" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  if [ -f /etc/hosts ]
    then
		echo "① /etc/hosts 파일 퍼미션 확인" >> $CREATE_FILE 2>&1
    	echo "----------------------------------------------------------------" >> $CREATE_FILE 2>&1	
      ls -alL /etc/hosts >> $CREATE_FILE 2>&1
		echo "② /etc/hosts 파일 내용" >> $CREATE_FILE 2>&1
		  cat /etc/hosts >> $CREATE_FILE 2>&1
    else
      echo " /etc/hosts 파일이 없습니다." >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1

  if [ -f /etc/hosts ]
   then
  if [ `ls -alL /etc/hosts | grep "...-------" | wc -l` -eq 1 ]
    then
      echo "★ U_20. 결과 : 양호" >> $CREATE_FILE 2>&1
    else
      echo "★ U_20. 결과 : 취약" >> $CREATE_FILE 2>&1
  fi
  fi


  result="완료"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_21() {
  echo -n "U_21. /etc/(x)inetd.conf 파일 소유자 및 권한 설정 >>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_21. /etc/(x)inetd.conf 파일 소유자 및 권한 설정 " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "▶ 점검기준 : /etc/(X)inetd.conf파일의 소유자가 root이고, 권한이 600 이하인 경우 양호" >> $CREATE_FILE 2>&1
  echo "▶ 시스템 현황" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1


  if [ -d /etc/xinetd.d ] 
    then
	  echo "☞ /etc/xinetd.d 디렉토리 내용 현황." >> $CREATE_FILE 2>&1
      ls -al /etc/xinetd.d/* >> $CREATE_FILE 2>&1
    else
      echo "/etc/xinetd.d 디렉토리가 없습니다." >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1

  if [ -f /etc/xinetd.conf ]
	then
	   echo "☞ /etc/xinetd.conf 파일 퍼미션 현황." >> $CREATE_FILE 2>&1
	   ls -al /etc/xinetd.conf
	else
		echo "/etc/xinetd.conf 파일이 없습니다." >> $CREATE_FILE 2>&1
	fi
	echo " " >> $CREATE_FILE 2>&1

  if [ -f /etc/inetd.conf ]
    then
	  echo "☞ /etc/inetd.conf 파일 퍼미션 현황." >> $CREATE_FILE 2>&1
      ls -al /etc/inetd.conf >> $CREATE_FILE 2>&1
    else
      echo "/etc/inetd.conf 파일이 없습니다." >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1

  echo " " > inetd.ahnlab

  if [ -f /etc/inetd.conf ]
    then
      if [ `ls -alL /etc/inetd.conf | awk '{print $1}' | grep '....------'| wc -l` -eq 1 ]
        then
          echo "양호" >> inetd.ahnlab
        else
          echo "취약" >> inetd.ahnlab
      fi
    else
      echo "" >> inetd.ahnlab
  fi

 if [ -f /etc/xinetd.conf ]
    then
      if [ `ls -alL /etc/xinetd.conf | awk '{print $1}' | grep '....------'| wc -l` -eq 0 ]
        then
          echo "취약" >> inetd.ahnlab
        else
          echo "양호" >> inetd.ahnlab
      fi
    else
      echo "" >> inetd.ahnlab
  fi
  echo " " >> $CREATE_FILE 2>&1

  if [ -d /etc/xinetd.d ]
    then
      if [ `ls -alL /etc/xinetd.d/* | awk '{print $1}' | grep '....------'| wc -l` -eq 0 ]
        then
          echo "취약" >> inetd.ahnlab
        else
          echo "양호" >> inetd.ahnlab
      fi
    else
      echo "" >> inetd.ahnlab
  fi

  if [ `cat inetd.ahnlab | grep "취약" | wc -l` -eq 0 ]
    then
      echo "★ U_21. 결과 : 양호" >> $CREATE_FILE 2>&1
    else
      echo "★ U_21. 결과 : 취약" >> $CREATE_FILE 2>&1
  fi

  rm -rf inetd.ahnlab

  result="완료"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_22() {
  echo -n "U_22. /etc/syslog.conf 파일 소유자 및 권한 설정 >>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_22. /etc/syslog.conf 파일 소유자 및 권한 설정 " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "▶ 점검기준 : /etc/syslog.conf 파일의 소유자가 root이고, 권한이 644 이하인 경우 양호" >> $CREATE_FILE 2>&1
  echo "▶ 시스템 현황" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1


	if [ -f  /etc/syslog.conf ] #20160105-02 start 
	then
		echo '☞ syslog.conf 파일 권한 ' >>  $CREATE_FILE 2>&1
		ls -alL /etc/syslog.conf  >> $CREATE_FILE 2>&1
	else
		echo "/etc/syslog.conf 파일이 없습니다"  >> $CREATE_FILE 2>&1
	fi
	echo " " >> $CREATE_FILE 2>&1
	if [ -f /etc/rsyslog.conf ]
	then
		echo '☞ rsyslog.conf 파일 권한 '  >> $CREATE_FILE 2>&1
		ls -alL /etc/rsyslog.conf >> $CREATE_FILE 2>&1
	else
		echo "/etc/rsyslog.conf 파일이 없습니다"  >> $CREATE_FILE 2>&1
	fi
	echo " " >> $CREATE_FILE 2>&1
	if [ -f /etc/syslog-ng.conf ]
	then
		echo '☞ syslog-ng.conf 파일 권한 '  >> $CREATE_FILE 2>&1
		ls -alL /etc/syslog-ng.conf  >> $CREATE_FILE 2>&1
   else
		echo "/etc/syslog-ng.conf 파일이 없습니다"  >> $CREATE_FILE 2>&1
	fi

	echo " " >> $CREATE_FILE 2>&1

	if [ -f /etc/syslog.conf ]
	then
		if [ `ls -alL /etc/syslog.conf | awk '{print $1}' | grep '...-.--.--' | wc -l` -eq 1 ]
			then
				echo "★ U_22. 결과 : 양호" >> $CREATE_FILE 2>&1
		else
			echo "★ U_22. 결과 : 취약" >> $CREATE_FILE 2>&1
		fi
	else if [ -f /etc/rsyslog.conf ]
	then 
		if [ `ls -alL /etc/rsyslog.conf | awk '{print $1}' | grep '...-.--.--' | wc -l` -eq 1 ]
			then
				echo "★ U_22. 결과 : 양호" >> $CREATE_FILE 2>&1
		else
			echo "★ U_22. 결과 : 취약" >> $CREATE_FILE 2>&1
		fi

	else if [ -f /etc/syslog-ng.conf ]
	then 
		if [ `ls -alL /etc/syslog-ng.conf | awk '{print $1}' | grep '...-.--.--' | wc -l` -eq 1 ]
			then
				echo "★ U_22. 결과 : 양호" >> $CREATE_FILE 2>&1
		else
			echo "★ U_22. 결과 : 취약" >> $CREATE_FILE 2>&1
		fi

	else
	echo "★ U_22. 결과 : 수동점검" >> $CREATE_FILE 2>&1
	fi
	fi
	fi
#20160105-02 end 

  result="완료"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_23() {
  echo -n "U_23. /etc/service 파일 소유자 및 권한 설정  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_23. /etc/service 파일 소유자 및 권한 설정 " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "▶ 점검기준 : /etc/service 파일의 소유자가 root이고, 권한이 644 이하인 경우 양호" >> $CREATE_FILE 2>&1
  echo "▶ 시스템 현황" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  if [ -f  /etc/services ]
    then
	 echo "① /etc/services 파일 퍼미션 확인" >> $CREATE_FILE 2>&1
     echo "------------------------------------------------------------------------------" >> $CREATE_FILE 2>&1	
      ls -alL /etc/services  >> $CREATE_FILE 2>&1
    else
      echo " /etc/services 파일이 없습니다"  >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1

  if [ -f /etc/services ]
    then
      if [ `ls -alL /etc/services | awk '{print $1}' | grep '.....--.--' | wc -l` -eq 1 ]
        then
          echo "★ U_23. 결과 : 양호" >> $CREATE_FILE 2>&1
       else
          echo "★ U_23. 결과 : 취약" >> $CREATE_FILE 2>&1
      fi
    else
      echo "★ U_23. 결과 : 수동점검" >> $CREATE_FILE 2>&1
  fi

  result="완료"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_24() {
  echo -n "U_24. SUID, SGID, Sticky bit 설정파일 점검 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_24. SUID, SGID, Sticky bit 설정파일 점검 " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "▶ 점검기준 : SUID, SGID, Sticky bit 권한이 부여된 파일을 점검하여 불필요하게 부여된 파일이 없을경우 양호" >> $CREATE_FILE 2>&1
  echo "▶ 시스템 현황" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  FILES="/sbin/dump /usr/bin/lpq-lpd /usr/bin/newgrp /sbin/restore /usr/bin/lpr /usr/sbin/lpc /sbin/unix_chkpwd /usr/bin/lpr-lpd /usr/sbin/lpc-lpd /usr/bin/at /usr/bin/lprm /usr/sbin/traceroute /usr/bin/lpq /usr/bin/lprm-lpd"

  for check_file in $FILES
    do
      if [ -f $check_file ]
        then
          if [ -g $check_file -o -u $check_file ]
            then
              echo `ls -alL $check_file` >> $CREATE_FILE 2>&1
            else
              echo $check_file "파일에 SUID, SGID가 부여되어 있지 않습니다" >> $CREATE_FILE 2>&1
          fi
        else
          echo $check_file "이 없습니다" >> $CREATE_FILE 2>&1
      fi
    done

  echo " " >> $CREATE_FILE 2>&1


  echo "setuid " > set.ahnlab

  FILES="/sbin/dump /usr/bin/lpq-lpd /usr/bin/newgrp /sbin/restore /usr/bin/lpr /usr/sbin/lpc /sbin/unix_chkpwd /usr/bin/lpr-lpd /usr/sbin/lpc-lpd /usr/bin/at /usr/bin/lprm /usr/sbin/traceroute /usr/bin/lpq /usr/bin/lprm-lpd"

  for check_file in $FILES
    do
      if [ -f $check_file ]
        then
          if [ `ls -alL $check_file | awk '{print $1}' | grep -i 's'| wc -l` -gt 0 ]
            then
              ls -alL $check_file |awk '{print $1}' | grep -i 's' >> set.ahnlab
            else
              echo " " >> set.ahnlab
          fi
      fi
    done

  if [ `cat set.ahnlab | awk '{print $1}' | grep -i 's' | wc -l` -gt 1 ]
    then
      echo "★ U_24. 결과 : 취약" >> $CREATE_FILE 2>&1
    else
      echo "★ U_24. 결과 : 양호" >> $CREATE_FILE 2>&1
  fi

  rm -rf set.ahnlab

  result="완료"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_25() {
  echo -n "U_25. 사용자, 시스템 시작파일 및 환경파일 소유자 및 권한 설정 >>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_25. 사용자, 시스템 시작파일 및 환경파일 소유자 및 권한 설정 " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "▶ 점검기준 : 홈 디렉터리 환경변수 파일 소유자가 해당 계정으로 지정되어 있고," >> $CREATE_FILE 2>&1
  echo "              홈 디렉터리 환경변수 파일에 소유자만 쓰기 권한이 부여되어 있는 경우 양호" >> $CREATE_FILE 2>&1
  echo "▶ 시스템 현황" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1


  echo " " >> $CREATE_FILE 2>&1
  HOMEDIRS=`cat /etc/passwd | awk -F":" 'length($6) > 0 {print $6}' | sort -u | grep -v '/bin/false' | grep -v 'nologin' | grep -v "#"`
  FILES=".profile .cshrc .kshrc .login .bash_profile .bashrc .bash_login .exrc .netrc .history .sh_history .bash_history .dtprofile"

  for file in $FILES
  do
    FILE=/$file
    if [ -f $FILE ]
      then
        ls -al $FILE >> $CREATE_FILE 2>&1
    fi
  done

  for dir in $HOMEDIRS
  do
    for file in $FILES
    do
      FILE=$dir/$file
        if [ -f $FILE ]
          then
          ls -al $FILE >> $CREATE_FILE 2>&1
        fi
    done
  done
  echo " " >> $CREATE_FILE 2>&1

  echo " " > home.ahnlab

  HOMEDIRS=`cat /etc/passwd | awk -F":" 'length($6) > 0 {print $6}' | sort -u | grep -v '/bin/false' | grep -v 'nologin' | grep -v "#"`
  FILES=".profile .cshrc .kshrc .login .bash_profile .bashrc .bash_login .exrc .netrc .history .sh_history .bash_history .dtprofile"

  for file in $FILES
    do
      if [ -f /$file ]
        then
          if [ `ls -alL /$file |  awk '{print $1}' | grep "........-." | wc -l` -eq 0 ]
            then
              echo "취약" >> home.ahnlab
            else
              echo "양호" >> home.ahnlab
          fi
        else
          echo "양호" >> home.ahnlab
      fi
    done

  for dir in $HOMEDIRS
    do
      for file in $FILES
        do
          if [ -f $dir/$file ]
            then
              if [ `ls -al $dir/$file | awk '{print $1}' | grep "........-." | wc -l` -eq 0 ]
                then
                  echo "취약" >> home.ahnlab
                else
                  echo "양호" >> home.ahnlab
              fi
            else
              echo "양호" >> home.ahnlab
          fi
        done
    done

  if [ `cat home.ahnlab | grep "취약" | wc -l` -eq 0 ]
    then
      echo "★ U_25. 결과 : 양호" >> $CREATE_FILE 2>&1
    else
      echo "★ U_25. 결과 : 취약" >> $CREATE_FILE 2>&1
  fi

  rm -rf home.ahnlab


  result="완료"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_26() {
  echo -n "U_26. world writable 파일 점검 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_26. world writable 파일 점검 " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "▶ 점검기준 : world writable 파일 존재 여부를 확인하고, 존재 시 설정이유를 확인하고 있는 경우 양호" >> $CREATE_FILE 2>&1
  echo "▶ 시스템 현황" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

for i in /home /tmp /etc /var #20160106-01 
	do
		find $i -name '*' -type d >> dir.txt   2>&1
done 

for D in `cat dir.txt`
	do
		find $D -perm -2 -ls | awk '{ print $3":"$5":"$6":"$11}' | grep -v ^l >>world.ahnlab  2>&1
			world=`ls -al world.ahnlab | awk '{print $5}'`
				if [ $world -gt 1000 ]
				then
					break 1 
				fi
done 

  if [ -s world.ahnlab ]
    then
	    cat world.ahnlab >> $CREATE_FILE 2>&1
    else
	  echo "☞ World Writable 권한이 부여된 파일이 발견되지 않았습니다." >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1

  if [ -s world.ahnlab ]
    then
      echo "★ U_26. 결과 : 취약" >> $CREATE_FILE 2>&1
    else
      echo "★ U_26. 결과 : 양호" >> $CREATE_FILE 2>&1
  fi

 rm -rf dir.txt  
  rm -rf world.ahnlab

  result="완료"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_27() {
  echo -n "U_27. /dev에 존재하지 않는 device 파일 점검 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_27. /dev에 존재하지 않는 device 파일 점검 " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "▶ 점검기준 : dev에 대한 파일 점검 후 존재하지 않은 device 파일을 제거한 경우 양호" >> $CREATE_FILE 2>&1
  echo "▶ 시스템 현황" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  echo "① 기반시설 점검기준 명령 : find /dev -type f -exec ls -l {} \;" >> $CREATE_FILE 2>&1
  echo "------------------------------------------------------------------------------" >> $CREATE_FILE 2>&1 
  find /dev -type f -exec ls -l {} \; > dev-file.ahnlab

  if [ -s dev-file.ahnlab ]
    then
	  cat dev-file.ahnlab >> $CREATE_FILE 2>&1
    else
  	  echo "☞ /dev 에 존재하지 않은 Device 파일이 발견되지 않았습니다." >> $CREATE_FILE 2>&1
  fi
  
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "디바이스 파일(charactor, block file) 점검 : find /dev -type [C B] -exec ls -l {} \;  " >> $CREATE_FILE 2>&1
  echo "major, minor 필드에 값이 올바르지 않은 경우 취약  " >> $CREATE_FILE 2>&1
  echo "------------------------------------------------------------------------------" >> $CREATE_FILE 2>&1 
  find /dev -type c -exec ls -l {} \; > dev-file2.ahnlab
  find /dev -type b -exec ls -l {} \; > dev-file2.ahnlab
  
  if [ -s dev-file2.ahnlab ]
    then
	  cat dev-file2.ahnlab >> $CREATE_FILE 2>&1
    else
  	  echo "☞ /dev 에 charactor, block Device 파일이 발견되지 않았습니다." >> $CREATE_FILE 2>&1
  fi
  


  echo " " >> $CREATE_FILE 2>&1

  if [ -s dev-file.ahnlab ]
    then
      echo "★ U_27. 결과 : 수동점검" >> $CREATE_FILE 2>&1
    else
      echo "★ U_27. 결과 : 양호" >> $CREATE_FILE 2>&1
  fi

  rm -rf dev-file.ahnlab
  rm -rf dev-file2.ahnlab

  result="완료"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_28() {
  echo -n "U_28. $HOME/.rhosts, hosts.equiv 사용 금지 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_28. $HOME/.rhosts, hosts.equiv 사용금지 " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "▶ 점검기준 : exec(512/tcp), login(513/tcp), shell(514/tcp)서비스를 사용하지 않거나, 사용 시 아래와 같은 설정이 적용된 경우 양호" >> $CREATE_FILE 2>&1
  echo "              1. /etc/hosts.equiv 및 $HOME/.rhosts 파일 소유자가 root 또는, 해당 계정인 경우" >> $CREATE_FILE 2>&1
  echo "              2. /etc/hosts.equiv 및 $HOME/.rhosts 파일 권한이 600 이하인 경우" >> $CREATE_FILE 2>&1
  echo "              3. /etc/hosts.equiv 및 $HOME/.rhosts 파일 설정에 '+' 설정이 없는 경우" >> $CREATE_FILE 2>&1
  echo "▶ 시스템 현황" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  SERVICE_INETD="shell|login|exec"

  echo "■ 서비스 포트 활성화 여부 확인" >> $CREATE_FILE 2>&1
  echo "------------------------- " >> $CREATE_FILE 2>&1
if [ `netstat -na | egrep ":512|:513|:514" | grep -i "listen" | grep -i "tcp" | wc -l` -ge 1 ]
  then
    netstat -na | egrep ":512|:513|:514" | grep -i "litsen" | grep -i "tcp" >> $CREATE_FILE 2>&1
    echo " " >> $CREATE_FILE 2>&1
    echo "r command Sevice Enable" >> $CREATE_FILE 2>&1
    echo "취약" >> trust.ahnlab
    echo " " >> $CREATE_FILE 2>&1
  
  
  echo "■ /etc/xinetd.d 서비스 " >> $CREATE_FILE 2>&1
  echo "------------------------- " >> $CREATE_FILE 2>&1
if [ -d /etc/xinetd.d/ ]; then
  if [ `ls -alL /etc/xinetd.d/* | egrep $SERVICE_INETD |egrep -v "grep|klogin|kshell|kexec" | wc -l` -gt 0 ]
    then
      ls -alL /etc/xinetd.d/* | egrep $SERVICE_INETD  >> $CREATE_FILE 2>&1
    else
      echo "r 서비스가 존재하지 않음" >> $CREATE_FILE 2>&1
  fi
fi
  echo " " >> $CREATE_FILE 2>&1
  echo "■ /etc/xinetd.d 내용 " >> $CREATE_FILE 2>&1
  echo "---------------------- " >> $CREATE_FILE 2>&1
if [ -d /etc/xinetd.d/ ]; then 
  if [ `ls -alL /etc/xinetd.d | egrep $SERVICE_INETD | egrep -v "grep|klogin|kshell|kexec" | wc -l` -gt 0 ]
    then
      for VVV in `ls -alL /etc/xinetd.d | egrep $SERVICE_INETD | egrep -v "grep|klogin|kshell|kexec" | awk '{print $9}'`
      do
        echo " $VVV 파일" >> $CREATE_FILE 2>&1
        cat /etc/xinetd.d/$VVV | grep -i "disable" >> $CREATE_FILE 2>&1
        echo "   " >> $CREATE_FILE 2>&1
      done
    else
      echo "xinetd.d디렉터리에 r 계열 파일이 없습니다" >> $CREATE_FILE 2>&1
  fi
fi
  echo " " >> $CREATE_FILE 2>&1

  SERVICE_INETD="rsh|rlogin|rexec|shell|login|exec"

  echo "■ inetd.conf 파일에서 'r' commnad 관련 서비스 상태" >> $CREATE_FILE 2>&1
  echo "----------------------------------------------------- " >> $CREATE_FILE 2>&1
  if [ -f /etc/inetd.conf ]
    then
      cat /etc/inetd.conf | grep -v '^ *#' | egrep $SERVICE_INETD | egrep -v "grep|klogin|kshell|kexec" >> $CREATE_FILE 2>&1
    else
      echo "/etc/inetd.conf 파일이 존재하지 않습니다." >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1

  if [ -d /etc/xinetd.d ]
    then
      if [ `ls -alL /etc/xinetd.d | egrep $SERVICE_INETD | egrep -v "grep|klogin|kshell|kexec" | wc -l` -gt 0 ]
        then
          for VVV in `ls -alL /etc/xinetd.d | egrep $SERVICE_INETD | egrep -v "grep|klogin|kshell|kexec" | awk '{print $9}'`
          do
            if [ `cat /etc/xinetd.d/$VVV | grep -i "disable" | grep -i "no" | wc -l` -gt 0 ]
              then
                echo "r command" > r_temp
              else
                echo "양호" >> trust.ahnlab
            fi
          done
        else
          echo "양호" >> trust.ahnlab
      fi
    elif [ -f /etc/inetd.conf ]
      then
        if [ `cat /etc/inetd.conf | grep -v '^ *#' | egrep $SERVICE_INETD | egrep -v "grep|klogin|kshell|kexec" |wc -l` -eq 0 ]
          then
            echo "양호" >> trust.ahnlab
          else
            echo "r command" > r_temp
        fi
      else
        echo "양호" >> trust.ahnlab
  fi


  HOMEDIRS=`cat /etc/passwd | awk -F":" 'length($6) > 0 {print $6}' | sort -u`
  FILES="/.rhosts"



  if [ -s r_temp ]
    then
	  echo "■ /etc/hosts.equiv 파일 현황 " >> $CREATE_FILE 2>&1
	  echo "-------------------------------- " >> $CREATE_FILE 2>&1
      if [ -f /etc/hosts.equiv ]
        then
          ls -alL /etc/hosts.equiv >> $CREATE_FILE 2>&1
          echo " " >> $CREATE_FILE 2>&1
          echo "/etc/hosts.equiv 파일 설정 내용" >> $CREATE_FILE 2>&1
          cat /etc/hosts.equiv >> $CREATE_FILE 2>&1
        else
          echo "/etc/hosts.equiv 파일이 존재하지 않습니다." >> $CREATE_FILE 2>&1
      fi
    else
      echo " " >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1

  if [ -s r_temp ]
    then
	  echo "■ $HOME/.rhosts 파일 현황 " >> $CREATE_FILE 2>&1
	  echo "-------------------------------- " >> $CREATE_FILE 2>&1
      for dir in $HOMEDIRS
        do
          for file in $FILES
            do
              if [ -f $dir$file ]
                then
                  ls -alL $dir$file  >> $CREATE_FILE 2>&1
                  echo " " >> $CREATE_FILE 2>&1
                  echo "- $dir$file 설정 내용" >> $CREATE_FILE 2>&1
                  cat $dir$file | grep -v "#" >> $CREATE_FILE 2>&1
                else
                  echo "없음" >> nothing.ahnlab
              fi
            done
        done
    else
      echo " " >> $CREATE_FILE 2>&1
  fi

  if [ -f nothing.ahnlab ]
    then
      echo "/.rhosts 파일이 존재하지 않습니다. " >> $CREATE_FILE 2>&1
  fi

  if [ -s r_temp ]
    then
      if [ -f /etc/hosts.equiv ]
        then
          if [ `ls -alL /etc/hosts.equiv |  awk '{print $1}' | grep "....------" | wc -l` -eq 1 ]
            then
              echo "양호" >> trust.ahnlab
            else
              echo "취약" >> trust.ahnlab
          fi
          if [ `cat /etc/hosts.equiv | grep "+" | grep -v "grep" | grep -v "#" | wc -l` -eq 0 ]
            then
              echo "양호" >> trust.ahnlab
            else
              echo "취약" >> trust.ahnlab
          fi
        else
          echo "양호" >> trust.ahnlab
      fi
    else
      echo "양호" >> trust.ahnlab
  fi


  if [ -s r_temp ]
    then
      for dir in $HOMEDIRS
	      do
	        for file in $FILES
	          do
	            if [ -f $dir$file ]
	              then
                  if [ `ls -alL $dir$file |  awk '{print $1}' | grep "....------" | wc -l` -eq 1 ]
                    then
                      echo "양호" >> trust.ahnlab
                    else
                      echo "취약" >> trust.ahnlab
                  fi
                  if [ `cat $dir$file | grep "+" | grep -v "grep" | grep -v "#" |wc -l ` -eq 0 ]
                    then
                      echo "양호" >> trust.ahnlab
                    else
                      echo "취약" >> trust.ahnlab
                  fi
                fi
            done
        done
    else
      echo "양호" >> trust.ahnlab
  fi

  echo " " >> $CREATE_FILE 2>&1

  if [ `cat trust.ahnlab | grep "취약" | wc -l` -eq 0 ]
    then
      echo "★ U_28. 결과 : 양호" >> $CREATE_FILE 2>&1
    else
      echo "★ U_28. 결과 : 취약" >> $CREATE_FILE 2>&1
  fi
else
    echo " " >> $CREATE_FILE 2>&1
    echo "r command Sevice Disable" >> $CREATE_FILE 2>&1
    echo " " >> $CREATE_FILE 2>&1
    echo "★ U_28. 결과 : 양호" >> $CREATE_FILE 2>&1
    echo " " >> $CREATE_FILE 2>&1
  fi

  rm -rf trust.ahnlab r_temp nothing.ahnlab

  result="완료"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_29() {
  echo -n "U_29. 접속 IP 및 포트 제한 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_29. 접속 IP 및 포트 제한 " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "▶ 점검기준 : /etc/hosts.deny 파일에 ALL Deny 설정 후" >> $CREATE_FILE 2>&1
  echo "              /etc/hosts.allow 파일에 접근을 허용할 특정 호스트를 등록한 경우" >> $CREATE_FILE 2>&1
  echo "▶ 시스템 현황" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  if [ -f /etc/hosts.deny ]
    then
      echo "☞ /etc/hosts.deny 파일 내용" >> $CREATE_FILE 2>&1
      cat /etc/hosts.deny >> $CREATE_FILE 2>&1
    else
      echo "/etc/hosts.deny 파일 없음" >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1

  if [ -f /etc/hosts.allow ]
    then
      echo "☞ /etc/hosts.allow 파일 내용" >> $CREATE_FILE 2>&1
      cat /etc/hosts.allow >> $CREATE_FILE 2>&1
    else
      echo "/etc/hosts.allow 파일 없음" >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1

  if [ -f /etc/hosts.deny ]
    then
      if [ `cat /etc/hosts.deny  | grep -v "#" | sed 's/ *//g' |  grep "ALL:ALL" |wc -l ` -gt 0 ]
        then
          echo "양호" >> IP_ACL.ahnlab
        else
          echo "취약" >> IP_ACL.ahnlab
      fi
    else
      echo "취약" >> IP_ACL.ahnlab
  fi

  if [ -f /etc/hosts.allow ]
    then
      if [ `cat /etc/hosts.allow | grep -v "#" | sed 's/ *//g' | grep -v "^$" | grep -v "ALL:ALL" | wc -l ` -gt 0 ]
        then
          echo "양호" >> IP_ACL.ahnlab
        else
          echo "취약" >> IP_ACL.ahnlab
      fi
    else
      echo "취약" >> IP_ACL.ahnlab
  fi


  if [ `cat IP_ACL.ahnlab | grep "취약" | wc -l` -eq 0 ]
    then
      echo "★ U_29. 결과 : 양호" >> $CREATE_FILE 2>&1
    else
      echo "★ U_29. 결과 : 취약" >> $CREATE_FILE 2>&1
  fi


rm -rf IP_ACL.ahnlab


  result="완료"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_30() {
  echo -n "U_30. hosts.lpd 파일 소유자 및 권한 설정 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_30. hosts.lpd 파일 소유자 및 권한 설정 " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "▶ 점검기준 : 파일의 소유자가 root이고 Other에 쓰기 권한이 부여되어 있지 않는 경우 양호" >> $CREATE_FILE 2>&1
  echo "▶ 시스템 현황" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  if [ -f /etc/hosts.lpd ]
    then
      ls -alL /etc/hosts.lpd  >> $CREATE_FILE 2>&1
		if [ `ls -alL /etc/hosts.lpd | awk '{print $1}' | grep '........-.' | wc -l` -eq 1 ]
        then
			 echo " " >> $CREATE_FILE 2>&1	
          echo "★ U_30. 결과 : 양호" >> $CREATE_FILE 2>&1
       else
			 
		    echo " " >> $CREATE_FILE 2>&1
          echo "★ U_30. 결과 : 취약" >> $CREATE_FILE 2>&1
      fi
	else
		echo "/etc/hosts.lpd 파일이 없습니다"  >> $CREATE_FILE 2>&1
		echo " " >> $CREATE_FILE 2>&1	
      echo "★ U_30. 결과 : 양호" >> $CREATE_FILE 2>&1
  fi


  result="완료"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_31() {
  echo -n "U_31. NIS 서비스 비활성화 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_31. NIS 서비스 비활성화 " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "▶ 점검기준 : 불필요한 NIS 서비스가 비활성화 되어 있는 경우 양호" >> $CREATE_FILE 2>&1
  echo "              업무상 사용하는 경우 양호(점검 후 인터뷰 시)" >> $CREATE_FILE 2>&1
  echo "▶ 시스템 현황" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  SERVICE="ypserv|ypbind|ypxfrd|rpc.yppasswdd|rpc.ypupdated"

  if [ `ps -ef | egrep $SERVICE | grep -v "grep" | wc -l` -eq 0 ]
    then
      echo "☞ NIS, NIS+ 서비스가 비실행중입니다." >> $CREATE_FILE 2>&1
      echo " " >> $CREATE_FILE 2>&1
      echo "★ U_31. 결과 : 양호" >> $CREATE_FILE 2>&1
    else
      ps -ef | egrep $SERVICE | grep -v "grep" >> $CREATE_FILE 2>&1
      echo " " >> $CREATE_FILE 2>&1
      echo "☞ NIS, NIS+ 서비스가 비실행중입니다." >> $CREATE_FILE 2>&1
      echo " " >> $CREATE_FILE 2>&1
      echo "★ U_31. 결과 : 취약" >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1

  result="완료"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_32() {
  echo -n "U_32. UMASK 설정 관리 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_32. UMASK 설정 관리 " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "▶ 점검기준 : UMASK 값이 022 이상으로 설정된 경우 양호" >> $CREATE_FILE 2>&1
  echo "▶ 시스템 현황" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
 
 echo "☞ UMASK 명령어(root계정 umask)  " >> $CREATE_FILE 2>&1
 echo "  " >> $CREATE_FILE 2>&1
 umask >> $CREATE_FILE 2>&1
 
 if [ `umask | awk -F"0" '$2 >= "22"' | wc -l` -eq 1 ]
		then
		  echo "양호" >> umask.ahnlab
		else
		  echo "취약" >> umask.ahnlab
 fi
 echo "  " >> $CREATE_FILE 2>&1
 
  echo "☞ /etc/profile 파일  " >> $CREATE_FILE 2>&1
  if [ -f /etc/profile ]
    then
      cat /etc/profile | grep -i umask >> $CREATE_FILE 2>&1
      if [ `cat /etc/profile | grep -i "umask" |grep -v "#" | awk -F"0" '$2 >= "22"' | wc -l` -eq 2 ]
      then
        echo "양호" >> umask.ahnlab
      else
        echo "취약" >> umask.ahnlab
      fi
    else
      echo "/etc/profile 파일이 없습니다.(수동점검)" >> $CREATE_FILE 2>&1
  fi
  
  echo "☞ /etc/bashrc 파일  " >> $CREATE_FILE 2>&1
  if [ -f /etc/bashrc ]
    then
      cat /etc/bashrc | grep -i umask >> $CREATE_FILE 2>&1
      if [ `cat /etc/bashrc | grep -i "umask" |grep -v "#" | awk -F"0" '$2 >= "22"' | wc -l` -eq 2 ]
      then
        echo "양호" >> umask.ahnlab
      else
        echo "취약" >> umask.ahnlab
      fi
    else
      echo "/etc/bashrc 파일이 없습니다.(수동점검)" >> $CREATE_FILE 2>&1
  fi

  echo "  " >> $CREATE_FILE 2>&1
  
  if [ `cat umask.ahnlab | grep "취약" | wc -l` -eq 0 ]
    then
      echo "★ U_32. 결과 : 양호" >> $CREATE_FILE 2>&1
    else
      echo "★ U_32. 결과 : 취약" >> $CREATE_FILE 2>&1
  fi

 rm -rf umask.ahnlab

  result="완료"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_33() {
  echo -n "U_33. 홈 디렉터리 소유자 및 권한 설정 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_33. 홈 디렉터리 소유자 및 권한 설정 " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "▶ 점검기준 : 홈 디렉터리 소유자가 해당 계정이고, 일반 사용자 쓰기 권한이 제거된 경우 양호" >> $CREATE_FILE 2>&1
  echo "▶ 시스템 현황" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  HOMEDIRS=`cat /etc/passwd | awk -F":" 'length($6) > 0 {print $6}' | sort -u | grep -v "#" | grep -v "/tmp" | grep -v "uucppublic" | grep -v "var" | grep -v "news" | uniq`
  
  for dir in $HOMEDIRS
    do
		if [ -d $dir ]; then
  	    ls -dal $dir | grep '\d.........' >> $CREATE_FILE 2>&1
		fi
    done
  echo " " >> $CREATE_FILE 2>&1

  echo " " > home.ahnlab
  HOMEDIRS=`cat /etc/passwd | awk -F":" 'length($6) > 0 {print $6}' | sort -u | grep -v "#" | grep -v "/tmp" | grep -v "uucppublic" | grep -v "var" | grep -v "news" | uniq`
  for dir in $HOMEDIRS
    do
      if [ -d $dir ]
        then
          if [ `ls -dal $dir |  awk '{print $1}' | grep "........-." | wc -l` -eq 1 ]
            then
              echo "양호" >> home.ahnlab 
            else
              echo "취약" >> home.ahnlab  
          fi
        else
          echo "양호" >> home.ahnlab
      fi
    done

  echo " " >> $CREATE_FILE 2>&1

  if [ `cat home.ahnlab | grep "취약" | wc -l` -eq 0 ]
    then
      echo "★ U_33. 결과 : 양호" >> $CREATE_FILE 2>&1
    else
      echo "★ U_33. 결과 : 취약" >> $CREATE_FILE 2>&1
  fi

  rm -rf home.ahnlab

  result="완료"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_34() {
  echo -n "U_34. 홈 디렉터리로 지정한 디렉터리의 존재 관리 >>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_34. 홈 디렉터리로 지정한 디렉터리의 존재 관리 " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "▶ 점검기준 : 홈 디렉터리가 존재하지 않는 계정이 발견되지 않은 경우 양호" >> $CREATE_FILE 2>&1
  echo "▶            root 계정을 제외한 일반 계정의 홈 디렉터리가 '/'가 아닌 경우 양호" >> $CREATE_FILE 2>&1
  echo "▶ 시스템 현황" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  echo "☞ 홈 디렉터리가 존재하지 않는 계정리스트" >> $CREATE_FILE 2>&1
  echo "------------------------------------------------------------------------------" >> $CREATE_FILE 2>&1

  echo " " > DHOME_pan.ahnlab
  
  HOMEDIRS=`cat /etc/passwd | egrep -v -i "nologin|false" | awk -F":" 'length($6) > 0 {print $6}' | sort -u | grep -v "#" | grep -v "/tmp" | grep -v "uucppublic" | uniq`

  for dir in $HOMEDIRS
    do
	    if [ ! -d $dir ]
	      then
		      awk -F: '$6=="'${dir}'" { print "● 계정명(홈디렉터리):"$1 "(" $6 ")" }' /etc/passwd >> $CREATE_FILE 2>&1
		      echo " " > Home.ahnlab
		    else
		      echo "없음" > no_Home.ahnlab
	    fi
    done

  echo " " >> $CREATE_FILE 2>&1

  if [ ! -f no_Home.ahnlab ]
    then
		  echo "홈 디렉터리가 존재하지 않은 계정이 발견되지 않았습니다" >> $CREATE_FILE 2>&1
    else
		  rm -rf no_Home.ahnlab
  fi
  
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  
  echo "☞ root 계정 외 '/'를 홈디렉터리로 사용하는 계정리스트" >> $CREATE_FILE 2>&1
  echo "------------------------------------------------------------------------------" >> $CREATE_FILE 2>&1
  
  if [ `cat /etc/passwd | egrep -v -i "nologin|false" | grep -v root | awk -F":" 'length($6) > 0' | awk -F":" '$6 == "/"' | wc -l` -eq 0 ]
  then
        echo "root 계정 외 '/'를 홈 디렉터리로 사용하는 계정이 존재하지 않습니다." >> $CREATE_FILE 2>&1
  else
        cat /etc/passwd | egrep -v -i "nologin|false" | grep -v root | awk -F":" 'length($6) > 0' | awk -F":" '$6 == "/"' >> $CREATE_FILE 2>&1
        echo "취약" >> DHOME_pan.ahnlab
  fi
        

  echo " " >> $CREATE_FILE 2>&1

  if [ ! -f Home.ahnlab ]
    then
      echo "양호" >> DHOME_pan.ahnlab
    else
      echo "취약" >> DHOME_pan.ahnlab
      rm -rf Home.ahnlab
  fi
  
  if [ `cat DHOME_pan.ahnlab | grep "취약" | wc -l` -eq 0 ]
    then
      echo "★ U_34. 결과 : 양호" >> $CREATE_FILE 2>&1
    else
      echo "★ U_34. 결과 : 취약" >> $CREATE_FILE 2>&1
      
	  
  fi
  rm -rf DHOME_pan.ahnlab
  
	
	
  result="완료"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_35() {
  echo -n "U_35. 숨겨진 파일 및 디렉터리 검색 및 제거 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_35. 숨겨진 파일 및 디렉터리 검색 및 제거 " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "▶ 점검기준 : 디렉터리 내 숨겨진 파일을 확인하여, 불필요한 파일 삭제를 완료한 경우 양호" >> $CREATE_FILE 2>&1
  echo "▶ 시스템 현황" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  echo "☞ 숨겨진 파일 및 디렉터리 현황" >> $CREATE_FILE 2>&1
  echo "--------------------------------------------------------------------" >> $CREATE_FILE 2>&1

  find /tmp -name ".*" -ls > hidden-file.ahnlab
  find /home -name ".*" -ls >> hidden-file.ahnlab
  find /usr -name ".*" -ls >> hidden-file.ahnlab
  find /var -name ".*" -ls >> hidden-file.ahnlab

  echo " " >> $CREATE_FILE 2>&1

  if [ -s hidden-file.ahnlab ]
    then
      cat hidden-file.ahnlab >> $CREATE_FILE 2>&1
      echo " " >> $CREATE_FILE 2>&1
      echo "★ U_35. 결과 : 수동점검" >> $CREATE_FILE 2>&1
      rm -rf hidden-file.ahnlab
    else
      echo "★ U_35. 결과 :  양호" >> $CREATE_FILE 2>&1
  fi

  result="완료"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_36() {
  echo -n "U_36. Finger 서비스 비활성화 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_36. Finger 서비스 비활성화 " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "▶ 점검기준 : Finger 서비스가 비활성화 되어 있는 경우 양호" >> $CREATE_FILE 2>&1
  echo "▶ 시스템 현황" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  SERVICE_INETD="finger"
  
  echo "■ finger 포트 활성화 상태" >> $CREATE_FILE 2>&1
  echo "--------------------------------------" >> $CREATE_FILE 2>&1
  if [ `netstat -na | grep :79 | grep -i listen | wc -l` -ge 1 ]
	then
		echo "finger 서비스 포트 활성화" >>$CREATE_FILE 2>&1
		echo "취약" >> service.ahnlab
		echo " " >> $CREATE_FILE 2>&1
		echo " finger Service Enable" >> $CREATE_FILE 2>&1
	

  echo "■ inetd.conf 파일에서 finger 상태" >> $CREATE_FILE 2>&1
  echo "-------------------------------------- " >> $CREATE_FILE 2>&1
  if [ -f /etc/inetd.conf ]
  	then
	    cat /etc/inetd.conf | grep -v "^ *#" | egrep $SERVICE_INETD >> $CREATE_FILE 2>&1
	  else
	    echo "/etc/inetd.conf 파일 존재하지 않음" >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  echo "■ /etc/xinetd.d 서비스" >> $CREATE_FILE 2>&1
  echo "-------------------------" >> $CREATE_FILE 2>&1
  if [ -d /etc/xinetd.d/ ]; then
   if [ `ls -alL /etc/xinetd.d/* | egrep $SERVICE_INETD | wc -l` -gt 0 ]
    then
      ls -alL /etc/xinetd.d/* | egrep $SERVICE_INETD  >> $CREATE_FILE 2>&1
    else
      echo "finger 서비스가 존재하지 않음" >> $CREATE_FILE 2>&1
   fi
  fi
  
  echo " " >> $CREATE_FILE 2>&1
  echo "■ /etc/xinetd.d 내용 " >> $CREATE_FILE 2>&1
  echo "------------------------" >> $CREATE_FILE 2>&1
  if [ -d /etc/xinetd.d ]; then
  if [ `ls -alL /etc/xinetd.d | egrep $SERVICE_INETD | wc -l` -gt 0 ]
    then
      for VVV in `ls -alL /etc/xinetd.d | egrep $SERVICE_INETD | grep -v "ssf" | awk '{print $9}'`
      do
        echo " $VVV 파일" >> $CREATE_FILE 2>&1
        cat /etc/xinetd.d/$VVV | grep -i "disable" >> $CREATE_FILE 2>&1
        echo "   " >> $CREATE_FILE 2>&1
      done
    else
      echo "xinetd.d디렉터리에 finger 파일이 없습니다" >> $CREATE_FILE 2>&1
  fi
  fi
  echo " " >> $CREATE_FILE 2>&1


  echo " " > service.ahnlab

  if [ -f /etc/inetd.conf ]
    then
      if [ `cat /etc/inetd.conf | grep -v '^ *#' | egrep $SERVICE_INETD | wc -l ` -eq 0 ]
        then
          echo "양호" >> service.ahnlab
        else
          echo "취약" >> service.ahnlab
      fi
    else
      echo "양호" >> service.ahnlab
  fi

  if [ -d /etc/xinetd.d ]
    then
      if [ `ls -alL /etc/xinetd.d | egrep $SERVICE_INETD | wc -l` -gt 0 ]
        then
          for VVV in `ls -alL /etc/xinetd.d | egrep $SERVICE_INETD | grep -v "ssf" | awk '{print $9}'`
          do
            if [ `cat /etc/xinetd.d/$VVV | grep -i "disable" | grep -i "no" | wc -l` -gt 0 ]
              then
                echo "취약" >> service.ahnlab
              else
                echo "양호" >> service.ahnlab
            fi
          done
        else
          echo "양호" >> service.ahnlab
      fi
    else
      echo "양호" >> service.ahnlab
  fi
 
  
  echo  ' ' 	>> $CREATE_FILE 2>&1
  if [ `cat service.ahnlab | grep "취약" | wc -l` -eq 0 ]
    then
      echo "★ U_36. 결과 : 양호" >> $CREATE_FILE 2>&1
    else
      echo "★ U_36. 결과 : 취약" >> $CREATE_FILE 2>&1
  fi
else
	echo "finger 서비스 포트 비활성화" >>$CREATE_FILE 2>&1
	echo " " >> $CREATE_FILE 2>&1
	echo " finger Service Disable" >> $CREATE_FILE 2>&1
	echo " " >> $CREATE_FILE 2>&1
	echo "★ U_36. 결과 : 양호" >> $CREATE_FILE 2>&1
		 
  fi
 
  rm -rf service.ahnlab

  result="완료"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}

U_37() {
  echo -n "U_37. Anonymous FTP 비활성화 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_37. Anonymous FTP 비활성화 " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "▶ 점검기준 : Anonymous FTP (익명 ftp) 접속을 차단한 경우 양호" >> $CREATE_FILE 2>&1
  echo "				      기본 FTP, ProFTP경우 ftp계정 삭제여부, vsFTP 경우 설정파일에서 anonymous_enable 부분 확인" >>  $CREATE_FILE 2>&1
  echo "▶ 시스템 현황" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  echo "① FTP 프로세스 활성화 상태" >> $CREATE_FILE 2>&1
  echo "------------------------------------------------------------------------------" >> $CREATE_FILE 2>&1
  if [ `ps -ef | grep ftp  | grep -v grep | wc -l` -eq 0 ];then
    echo " " >> $CREATE_FILE 2>&1
    echo "☞ ftp 서비스 비 실행중 " >> $CREATE_FILE 2>&1
  else
    echo " " >> $CREATE_FILE 2>&1
    ps -ef | grep ftp  | grep -v grep >> $CREATE_FILE >> $CREATE_FILE 2>&1
    echo "☞ ftp 서비스 실행중 " >> $CREATE_FILE 2>&1
    
  fi
  
  if [ -f /etc/inetd.conf ]
    then
      if [ `cat /etc/inetd.conf | grep -v '#' | grep ftp  | grep -v "tftp" |  wc -l` -gt 0  ]
        then
          echo "ftp enable" >> ftpps.ahnlab
      fi
  fi

  ps -ef | grep ftp  | grep -v grep | grep -v "tftp" >> ftpps.ahnlab
  echo " " >> $CREATE_FILE 2>&1

  anony_vsftp="/etc/vsftpd/vsftpd.conf /etc/vsftpd.conf"
 
  echo "② FTP Anonymous 관련 현황" >> $CREATE_FILE 2>&1
  echo "------------------------------------------------------------------------------" >> $CREATE_FILE 2>&1 
  if [ `cat ftpps.ahnlab | grep ftp | grep -v grep | wc -l` -gt 0 ]
    then
      if [ -f /etc/passwd ]
        then
    echo "■ /etc/passwd 파일 ftp 계정 존재여부" >> $CREATE_FILE 2>&1
          cat /etc/passwd | grep "ftp" >> $CREATE_FILE 2>&1
        else
          echo "/etc/passwd 파일이 없습니다. " >> $CREATE_FILE 2>&1
      fi  
   echo " " >> $CREATE_FILE 2>&1
   
   for file in $anony_vsftp
    do
    if [ -f $file ]
   then
     echo "■ "$file"파일 내 anonymous enable 설정" >> $CREATE_FILE 2>&1
     cat $file | grep -i "anonymous_enable" >> $CREATE_FILE 2>&1
    fi
    done 
    #vsftpd 확인 추가
    
    else
      echo "☞ ftp 서비스 비 실행중 " >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1
  
  echo " " > anony.ahnlab

  if [ `cat ftpps.ahnlab | grep ftp | grep -v grep | wc -l` -gt 0 ]
    then
      if [ `grep -v "^ *#" /etc/passwd | grep "ftp" | wc -l` -gt 0 ]
        then
          echo "취약" >> anony.ahnlab
      else
          echo "양호" >> anony.ahnlab
      fi
   
   for file in $anony_vsftp
    do
    if [ -f $file ]
   then
     if [ `cat $file | grep -i "anonymous_enable" | grep -i "yes" | grep -v "#" | wc -l` -eq 0 ]
      then
        echo "양호" >> anony.ahnlab
      else
        echo "취약" >> anony.ahnlab
     fi
    fi
    done  
   #vsftp 확인 추가
   
    else
      echo "양호" >> anony.ahnlab
  fi

  if [ `cat anony.ahnlab | grep "취약" | wc -l` -eq 0 ]
    then
      echo "★ U_37. 결과 : 양호" >> $CREATE_FILE 2>&1
    else
      echo "★ U_37. 결과 : 취약" >> $CREATE_FILE 2>&1
  fi
  

  rm -rf anony.ahnlab

    	


  result="완료"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_38() {
  echo -n "U_38. r 계열 서비스 비활성화  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_38. r 계열 서비스 비활성화 " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "▶ 점검기준 : r 계열 서비스가 비활성화 되어 있는 경우 양호" >> $CREATE_FILE 2>&1
  echo "▶ 시스템 현황" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  SERVICE_INETD="shell|login|exec|rsh|rlogin|rexec"
  
  echo "■ 서비스 포트 활성화 여부 확인" >> $CREATE_FILE 2>&1
  echo "------------------------- " >> $CREATE_FILE 2>&1
if [ `netstat -na | egrep ":512|:513|:514" | grep -i "litsen" | grep -i "tcp" | wc -l` -ge 1 ]
  then
    netstat -na | egrep ":512|:513|:514" | grep -i "litsen" | grep -i "tcp" >> $CREATE_FILE 2>&1
    echo " " >> $CREATE_FILE 2>&1
    echo "r command Sevice Enable" >> $CREATE_FILE 2>&1
    echo "취약" >> test.s
    echo " " >> $CREATE_FILE 2>&1

  echo " " >> $CREATE_FILE 2>&1
  echo "■ /etc/xinetd.d 서비스 " >> $CREATE_FILE 2>&1
  echo "------------------------- " >> $CREATE_FILE 2>&1
if [ -d /etc/xinetd.d/ ]; then
  if [ `ls -alL /etc/xinetd.d/* | egrep $SERVICE_INETD |egrep -v "grep|klogin|kshell|kexec" | wc -l` -gt 0 ]
    then
      ls -alL /etc/xinetd.d/* | egrep $SERVICE_INETD  >> $CREATE_FILE 2>&1
    else
      echo "r 서비스가 존재하지 않음" >> $CREATE_FILE 2>&1
  fi
fi
  echo " " >> $CREATE_FILE 2>&1
  echo "■ /etc/xinetd.d 내용 " >> $CREATE_FILE 2>&1
  echo "---------------------- " >> $CREATE_FILE 2>&1
if [ -d /etc/xinetd.d ]; then
  if [ `ls -alL /etc/xinetd.d | egrep $SERVICE_INETD | egrep -v "grep|klogin|kshell|kexec" | wc -l` -gt 0 ]
    then
      for VVV in `ls -alL /etc/xinetd.d | egrep $SERVICE_INETD | egrep -v "grep|klogin|kshell|kexec" | awk '{print $9}'`
      do
        echo " $VVV 파일" >> $CREATE_FILE 2>&1
        cat /etc/xinetd.d/$VVV | grep -i "disable" >> $CREATE_FILE 2>&1
        echo "   " >> $CREATE_FILE 2>&1
      done
    else
      echo "xinetd.d디렉터리에 r 계열 파일이 없습니다" >> $CREATE_FILE 2>&1
  fi
fi
  echo " " >> $CREATE_FILE 2>&1

  
  echo "■ inetd.conf 파일에서 'r' commnad 관련 서비스 상태" >> $CREATE_FILE 2>&1
  echo "----------------------------------------------------- " >> $CREATE_FILE 2>&1
  if [ -f /etc/inetd.conf ]
    then
      cat /etc/inetd.conf | grep -v '^ *#' | egrep $SERVICE_INETD | egrep -v "grep|klogin|kshell|kexec" >> $CREATE_FILE 2>&1
    else
      echo "/etc/inetd.conf 파일이 존재하지 않습니다." >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1

  if [ -d /etc/xinetd.d ]
    then
      if [ `ls -alL /etc/xinetd.d | egrep $SERVICE_INETD | egrep -v "grep|klogin|kshell|kexec" | wc -l` -gt 0 ]
        then
          for VVV in `ls -alL /etc/xinetd.d | egrep $SERVICE_INETD | egrep -v "grep|klogin|kshell|kexec" | awk '{print $9}'`
          do
            if [ `cat /etc/xinetd.d/$VVV | grep -i "disable" | grep -i "no" | wc -l` -gt 0 ]
              then
						
                echo "취약"  >> test.s
                
              else
                echo "양호" >> test.s
            fi
          done
        else
          echo "양호" >> test.s
      fi
    elif [ -f /etc/inetd.conf ]
      then
        if [ `cat /etc/inetd.conf | grep -v '^ *#' | egrep $SERVICE_INETD | egrep -v "grep|klogin|kshell|kexec" |wc -l` -eq 0 ]
          then
            echo "양호" >> test.s
          else
            echo "취약" >> test.s
            
        fi
      else
        echo "양호" >> test.s
  fi
	
if [ -f test.s ];then
  if [ `cat test.s | grep "취약" | wc -l` -eq 0 ]
    then
      echo "★ U_38. 결과 : 양호" >> $CREATE_FILE 2>&1
    else
      echo "★ U_38. 결과 : 취약" >> $CREATE_FILE 2>&1
  fi
fi


else
    echo " " >> $CREATE_FILE 2>&1
    echo "r command Sevice Disable" >> $CREATE_FILE 2>&1
    echo " " >> $CREATE_FILE 2>&1
    echo "★ U_28. 결과 : 양호" >> $CREATE_FILE 2>&1
    echo " " >> $CREATE_FILE 2>&1
  fi
  
  rm -rf r_temp
  rm -rf test.s

  result="완료"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_39() {
  echo -n "U_39. cron 파일 소유자 및 권한 설정  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_39. cron 파일 소유자 및 권한 설정 " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "▶ 점검기준 : cron 파일 소유자가 root이고, 권한이 640 이하인 경우 양호" >> $CREATE_FILE 2>&1
  echo "              두개의 파일 모두 없을 경우 OS 버전마다 루트만 사용할 수 있는 경우와 모든 사용자가 사용할 수 있는 경우가 있으므로 담당자 확인 필요" >>  $CREATE_FILE 2>&1
  echo "▶ 시스템 현황" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  crons="/etc/crontab /etc/cron.daily/* /etc/cron.hourly/* /etc/cron.monthly/* /etc/cron.weekly/* /var/spool/cron/*"
  crond="/etc/cron.deny /etc/cron.allow"

  echo "① Cron 프로세스 활성화 상태" >> $CREATE_FILE 2>&1
  echo "----------------------------" >> $CREATE_FILE 2>&1 
  if [ `ps -ef | grep cron | grep -v grep | wc -l` -ge 1 ];then
    ps -ef | grep cron | grep -v grep >> $CREATE_FILE 2>&1
	  echo " " >> $CREATE_FILE 2>&1
	  echo "☞ cron Service Enable"  >> $CREATE_FILE 2>&1
	  echo " " >> $CREATE_FILE 2>&1
	   
  echo "② Cron 파일 권한  " >> $CREATE_FILE 2>&1
  echo "----------------------------" >> $CREATE_FILE 2>&1
   for check_dir in $crons
   do
    if [ -f $check_dir ]
      then
        ls -alL $check_dir >> $CREATE_FILE 2>&1
      else
        echo $check_dir "이 없습니다" >> $CREATE_FILE 2>&1
    fi
  done
  echo " " >>$CREATE_FILE 2>&1
  echo "③ Cron.allow, Cron.deny 파일 내용" >> $CREATE_FILE 2>&1
  echo "----------------------------" >> $CREATE_FILE 2>&1
	for check_dir in $crond
   do
    if [ -f $check_dir ]
      then
        ls -alL $check_dir >> $CREATE_FILE 2>&1
			if [ `cat $check_dir | wc -l` -ge 1 ]
			then
				echo "-----------------------" >> $CREATE_FILE 2>&1
				echo $check_dir'파일의 내용'>>$CREATE_FILE 2>&1
				cat $check_dir >> $CREATE_FILE 2>&1
				echo " " >>$CREATE_FILE 2>&1
			else
				echo "-----------------------" >> $CREATE_FILE 2>&1
				echo $check_dir"파일의 내용없음">> $CREATE_FILE 2>&1
        echo " " >>$CREATE_FILE 2>&1
				echo "취약" >> crontab.ahnlab
			fi
    else
      echo $check_dir"파일이 없습니다" >> $CREATE_FILE 2>&1
    fi
  done

  echo " " >> $CREATE_FILE 2>&1

  echo " " > crontab.ahnlab
     
  for check_dir in $crons
  do
	if [ -f $check_dir ] 
	then
    if [  `ls -alL $check_dir | awk '{print $1}' |grep  '.......---' |wc -l` -eq 0 ]
      then
        echo "취약" >> crontab.ahnlab
      else
        echo "양호" >> crontab.ahnlab
    fi
	fi
  done

  for check_dir in $crond
  do
	if [ -f $check_dir ] 
	then
    if [  `ls -alL $check_dir | awk '{print $1}' |grep  '.......---' |wc -l` -eq 0 ]
      then
        echo "취약" >> crontab.ahnlab
      else
			if [ `cat $check_dir | wc -l` -ge 1 ]
			then 
        		echo "양호" >> crontab.ahnlab
			else
				echo "취약" >> crontab.ahnlab
			fi
	  fi
	fi
  done
else
 	echo "☞ cron Service Disable"  >> $CREATE_FILE 2>&1
	echo " " >> $CREATE_FILE 2>&1
	echo "양호" >> crontab.ahnlab
fi	
  echo " " >> $CREATE_FILE 2>&1

  if [ `cat crontab.ahnlab | grep "취약" | wc -l` -eq 0 ]
    then
      echo "★ U_39. 결과 : 양호" >> $CREATE_FILE 2>&1
    else
      echo "★ U_39. 결과 : 취약" >> $CREATE_FILE 2>&1
  fi



  rm -rf crontab.ahnlab

  result="완료"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_40() {
  echo -n "U_40. DoS 공격에 취약한 서비스 비활성화  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_40. DoS 공격에 취약한 서비스 비활성화 " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "▶ 점검기준 : DoS 공격에 취약한 echo, discard, daytime, chargen 서비스가 비활성화 된 경우 양호" >> $CREATE_FILE 2>&1
  echo "▶ 시스템 현황" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  SERVICE_INETD="echo|discard|daytime|chargen"


  echo "■ inetd.conf 파일에서 echo, discard, daytime, chargen 상태" >> $CREATE_FILE 2>&1
  echo "----------------------------------------------------------- " >> $CREATE_FILE 2>&1
	if [ -f /etc/inetd.conf ]
  	then
	    cat /etc/inetd.conf | grep -v "^ *#" | egrep $SERVICE_INETD >> $CREATE_FILE 2>&1
	  else
	    echo "/etc/inetd.conf 파일 존재하지 않음" >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  echo "■ /etc/xinetd.d 서비스" >> $CREATE_FILE 2>&1
  echo "-------------------------" >> $CREATE_FILE 2>&1
if [ -d /etc/xinetd.d/ ]; then
  if [ `ls -alL /etc/xinetd.d/* | egrep $SERVICE_INETD | wc -l` -gt 0 ]
    then
      ls -alL /etc/xinetd.d/* | egrep $SERVICE_INETD  >> $CREATE_FILE 2>&1
    else
      echo "DoS 공격에 취약한 서비스가 존재하지 않음" >> $CREATE_FILE 2>&1
  fi
fi
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  
  echo "■ /etc/xinetd.d 내용 " >> $CREATE_FILE 2>&1
  echo "------------------------" >> $CREATE_FILE 2>&1
if [ -d /etc/xinetd.d ]; then
  if [ `ls -alL /etc/xinetd.d | egrep $SERVICE_INETD | wc -l` -gt 0 ]
    then
      for VVV in `ls -alL /etc/xinetd.d | egrep $SERVICE_INETD | grep -v "ssf" | awk '{print $9}'`
      do
        echo " $VVV 파일" >> $CREATE_FILE 2>&1
        cat /etc/xinetd.d/$VVV | grep -i "disable" >> $CREATE_FILE 2>&1
        echo "   " >> $CREATE_FILE 2>&1
      done
    else
      echo "xinetd.d 디렉터리에 DoS에 취약한 서비스 파일이 없습니다" >> $CREATE_FILE 2>&1
  fi
fi
  echo " " >> $CREATE_FILE 2>&1


  echo " " > service.ahnlab

  if [ -f /etc/inetd.conf ]
    then
      if [ `cat /etc/inetd.conf | grep -v '^ *#' | egrep $SERVICE_INETD | wc -l ` -eq 0 ]
        then
          echo "양호" >> service.ahnlab
        else
          echo "취약" >> service.ahnlab
      fi
    else
      echo "양호" >> service.ahnlab
  fi

  if [ -d /etc/xinetd.d ]
    then
      if [ `ls -alL /etc/xinetd.d | egrep $SERVICE_INETD | wc -l` -gt 0 ]
        then
          for VVV in `ls -alL /etc/xinetd.d | egrep $SERVICE_INETD | grep -v "ssf" | awk '{print $9}'`
          do
            if [ `cat /etc/xinetd.d/$VVV | grep -i "disable" | grep -i "no" | wc -l` -gt 0 ]
              then
                echo "취약" >> service.ahnlab
              else
                echo "양호" >> service.ahnlab
            fi
          done
        else
          echo "양호" >> service.ahnlab
      fi
    else
      echo "양호" >> service.ahnlab
  fi


  if [ `cat service.ahnlab | grep "취약" | wc -l` -eq 0 ]
    then
      echo "★ U_40. 결과 : 양호" >> $CREATE_FILE 2>&1
    else
      echo "★ U_40. 결과 : 취약" >> $CREATE_FILE 2>&1
  fi

  rm -rf service.ahnlab

  result="완료"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_41() {
  echo -n "U_41. NFS 서비스 비활성화  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_41. NFS 서비스 비활성화 " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "▶ 점검기준 : NFS 서비스 관련 데몬이 비활성화 되어 있는 경우 양호" >> $CREATE_FILE 2>&1 
  echo "▶ 시스템 현황" >> $CREATE_FILE 2>&1 
  echo " " >> $CREATE_FILE 2>&1 
 
  echo "① NFS Server Daemon(nfsd)확인" >> $CREATE_FILE 2>&1
  echo "------------------------------------------------------------------------------" >> $CREATE_FILE 2>&1

  if [ `ps -ef | grep "nfsd" | egrep -v "statdaemon|automountd|emi" | grep -v "grep" | wc -l` -gt 0 ] 
    then
      ps -ef | grep "nfsd" | egrep -v "statdaemon|automountd|emi" | grep -v "grep" >> $CREATE_FILE 2>&1
      echo "취약" >> nfs-A.ahnlab
		echo "☞ NFS Service Enable" >> $CREATE_FILE 2>&1
    else
      echo "☞ NFS Service Disable" >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1

  echo "② NFS Client Daemon(statd,lockd)확인" >> $CREATE_FILE 2>&1
  echo "------------------------------------------------------------------------------" >> $CREATE_FILE 2>&1

  if [ `ps -ef | egrep "statd|lockd" | egrep -v "grep|emi|statdaemon|dsvclockd" | wc -l` -gt 0 ] 
    then
      ps -ef | egrep "statd|lockd" | egrep -v "grep|emi|statdaemon|dsvclockd" >> $CREATE_FILE 2>&1
      echo "취약" >> nfs-A.ahnlab
    else
      echo "☞ NFS Client(statd,lockd) Disable" >> $CREATE_FILE 2>&1
  fi


  echo " " >> $CREATE_FILE 2>&1


  if [ `cat nfs-A.ahnlab | grep "취약" | wc -l` -eq 0 ]
    then
      echo "★ U_41. 결과 : 양호" >> $CREATE_FILE 2>&1
    else
      echo "★ U_41. 결과 : 취약" >> $CREATE_FILE 2>&1
  fi

  rm -rf nfs-A.ahnlab
 
  result="완료" 
  echo " " >> $CREATE_FILE 2>&1 
  echo " " >> $CREATE_FILE 2>&1 
  echo "[$result]" 
  echo " " 
}


U_42() {
  echo -n "U_42. NFS 접근통제  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_42. NFS 접근통제 " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "▶ 점검기준 : NFS 서비스를 사용하지 않거나, 사용 시 everyone 공유를 제한한 경우 양호" >> $CREATE_FILE 2>&1
  echo "▶ 시스템 현황" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

   ps -ef | grep "nfsd" | egrep -v "grep|statdaemon|automountd" | grep -v "grep" >> $CREATE_FILE 2>&1  #20160106-01 
  echo " " >> $CREATE_FILE 2>&1 
   
  if [ `ps -ef | grep "nfsd" | egrep -v "grep|statdaemon|automountd" | grep -v "grep" | wc -l` -eq 0 ] 
    then
		  echo "☞ NFS Service Disable" >> $CREATE_FILE 2>&1
		  echo " " >> $CREATE_FILE 2>&1 
		  echo "★ U_42. 결과 : 양호" >> $CREATE_FILE 2>&1 
	else 
		if [ -f /etc/exports ]; then
			echo "/etc/exports 파일의 내용" >> $CREATE_FILE 2>&1
			if [ `cat /etc/exports | wc -l` -ge 1 ]; then
				cat /etc/exports  >> $CREATE_FILE 2>&1 
				echo " " >> $CREATE_FILE 2>&1
				echo "★ U_42. 결과 : 수동점검" >> $CREATE_FILE 2>&1 
			else
				echo "/etc/exports 파일의 내용없음" >> $CREATE_FILE 2>&1
				echo " " >> $CREATE_FILE 2>&1
				echo "★ U_42. 결과 : 취약" >> $CREATE_FILE 2>&1 
			fi
		else 
			echo "/etc/exports 파일이 존재하지 않습니다"  >> $CREATE_FILE 2>&1
			echo " " >> $CREATE_FILE 2>&1			
			echo "★ U_42. 결과 : 취약" >> $CREATE_FILE 2>&1 
		fi 
	fi 
	
	rm -rf nfs_export.txt
	
  result="완료" 
  echo " " >> $CREATE_FILE 2>&1 
  echo " " >> $CREATE_FILE 2>&1 
  echo "[$result]" 
  echo " " 

}


U_43() {
  echo -n "U_43. automountd 제거  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_43. automountd 제거 " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "▶ 점검기준 : automountd 서비스가 비활성화 되어 있는 경우 양호" >> $CREATE_FILE 2>&1
  echo "▶ 시스템 현황" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  echo "☞ Automount 데몬 확인 " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  ps -ef | egrep 'automountd|autofs' | grep -v "grep" | egrep -v "grep|statdaemon|emi" >> $CREATE_FILE 2>&1

  echo " " >> $CREATE_FILE 2>&1
 # ls -al /etc/rc*.d/* | grep -i "auto" | grep "/S" >> $CREATE_FILE 2>&1

  echo " " >> $CREATE_FILE 2>&1

  if [ `ps -ef | egrep 'automountd|autofs' | grep -v "grep" | egrep -v "grep|statdaemon|emi"  | wc -l` -eq 0 ]
    then
      echo "automount 데몬이 없습니다." >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1


  if [ `ps -ef | egrep 'automountd|autofs' | grep -v "grep" | egrep -v "grep|statdaemon|emi" | wc -l` -eq 0 ]
    then
      echo "★ U_43. 결과 : 양호" >> $CREATE_FILE 2>&1
    else
      echo "★ U_43. 결과 : 취약" >> $CREATE_FILE 2>&1
  fi

  result="완료"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_44() {
  echo -n "U_44. RPC 서비스 확인  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_44. RPC 서비스 확인 " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "▶ 점검기준 : 불필요한 RPC 서비스가 비활성화 되어 있는 경우 양호" >> $CREATE_FILE 2>&1
  echo "▶ 시스템 현황" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1


  SERVICE_INETD="rpc.cmsd|rpc.ttdbserverd|sadmind|ruserd|walld|sprayd|rstatd|rpc.nisd|rexd|rpc.pcnfsd|rpc.statd|rpc.ypupdated|rpc.rquotad|kcms_server|cachefsd"

  echo "■ inetd.conf 파일에서 RPC 관련 서비스 상태" >> $CREATE_FILE 2>&1
  echo "---------------------------------------------- " >> $CREATE_FILE 2>&1
	if [ -f /etc/inetd.conf ]
  	then
	    cat /etc/inetd.conf | grep -v "^ *#" | egrep $SERVICE_INETD >> $CREATE_FILE 2>&1
	  else
	    echo "/etc/inetd.conf 파일 존재하지 않음" >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  

  echo "■ /etc/xinetd.d 서비스" >> $CREATE_FILE 2>&1
  echo "--------------------------" >> $CREATE_FILE 2>&1

  if [ -d /etc/xinetd.d ]
    then
      if [ `ls -alL /etc/xinetd.d/* | egrep $SERVICE_INETD | wc -l` -eq 0 ]
        then
          echo "/etc/xinetd.d RPC 서비스가 없음" >> $CREATE_FILE 2>&1
        else
          ls -alL /etc/xinetd.d/* | egrep $SERVICE_INETD >> $CREATE_FILE 2>&1
      fi
    else
      echo "/etc/xinetd.d 디렉토리가 존재하지 않습니다. " >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  echo "■ /etc/xinetd.d 내용 " >> $CREATE_FILE 2>&1
  echo "---------------------" >> $CREATE_FILE 2>&1
if [ -d /etc/xinetd.d ]; then
  if [ `ls -alL /etc/xinetd.d | egrep $SERVICE_INETD | wc -l` -gt 0 ]
    then
      for VVV in `ls -alL /etc/xinetd.d | egrep $SERVICE_INETD | grep -v "ssf" | awk '{print $9}'`
      do
        echo " $VVV 파일" >> $CREATE_FILE 2>&1
        cat /etc/xinetd.d/$VVV | grep -i "disable" >> $CREATE_FILE 2>&1
        echo "   " >> $CREATE_FILE 2>&1
      done
    else
      echo "xinetd.d에 파일이 없습니다" >> $CREATE_FILE 2>&1
  fi
fi

  echo " " > rpc.ahnlab

  SERVICE_INETD="rpc.cmsd|rpc.ttdbserverd|sadmind|ruserd|walld|sprayd|rstatd|rpc.nisd|rexd|rpc.pcnfsd|rpc.statd|rpc.ypupdated|rpc.rquotad|kcms_server|cachefsd"

  echo " " >> $CREATE_FILE 2>&1

  if [ -f /etc/inetd.conf ]
    then
      if [ `cat /etc/inetd.conf | grep -v '^ *#' | egrep $SERVICE_INETD | wc -l ` -eq 0 ]
        then
          echo "양호" >> rpc.ahnlab
        else
          echo "취약" >> rpc.ahnlab
      fi
    else
      echo "양호" >> rpc.ahnlab
  fi

  if [ -d /etc/xinetd.d ]
    then
      if [ `ls -alL /etc/xinetd.d | egrep $SERVICE_INETD | wc -l` -gt 0 ]
        then
          for VVV in `ls -alL /etc/xinetd.d | egrep $SERVICE_INETD | grep -v "ssf" | awk '{print $9}'`
          do
            if [ `cat /etc/xinetd.d/$VVV | grep -i "disable" | grep -i "no" | wc -l` -gt 0 ]
              then
                echo "취약" >> rpc.ahnlab
              else
                echo "양호" >> rpc.ahnlab
            fi
          done
        else
          echo "양호" >> rpc.ahnlab
      fi
    else
      echo "양호" >> rpc.ahnlab
  fi

  if [ `cat rpc.ahnlab | grep "취약" | wc -l` -eq 0 ]
    then
      echo "★ U_44. 결과 : 양호" >> $CREATE_FILE 2>&1
    else
      echo "★ U_44. 결과 : 취약" >> $CREATE_FILE 2>&1
  fi

  rm -rf rpc.ahnlab

  result="완료"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_45() {
  echo -n "U_45. NIS, NIS+ 점검  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_45. NIS, NIS+ 점검 " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "▶ 점검기준 : NIS 서비스가 비활성화 되어 있거나, 필요 시 NIS+를 사용하는 경우 양호" >> $CREATE_FILE 2>&1
  echo "▶ 시스템 현황" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  SERVICE="ypserv|ypbind|ypxfrd|rpc.yppasswdd|rpc.ypupdated"

  if [ `ps -ef | egrep $SERVICE | grep -v "grep" | wc -l` -eq 0 ]
    then
	    echo "☞ NIS, NIS+ Service Disable" >> $CREATE_FILE 2>&1
    else
	    ps -ef | egrep $SERVICE | grep -v "grep" >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1

  if [ `ps -ef | egrep $SERVICE | grep -v "grep" | wc -l` -eq 0 ]
    then
      echo "★ U_45. 결과 : 양호" >> $CREATE_FILE 2>&1
    else
      echo "★ U_45. 결과 : 취약" >> $CREATE_FILE 2>&1
  fi

  result="완료"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_46() {
  echo -n "U_46. tffp, talk 서비스 비활성화  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_46. tftp, talk 서비스 비활성화 " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "▶ 점검기준 : tftp, talk, ntalk 서비스가 비활성화 되어 있는 경우 양호" >> $CREATE_FILE 2>&1
  echo "▶ 시스템 현황" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  SERVICE_INETD="tftp|talk|ntalk"


  echo "■ inetd.conf 파일에서 tftp, talk 상태" >> $CREATE_FILE 2>&1
  echo "-------------------------------------- " >> $CREATE_FILE 2>&1
	if [ -f /etc/inetd.conf ]
  	then
	    cat /etc/inetd.conf | grep -v "^ *#" | egrep $SERVICE_INETD >> $CREATE_FILE 2>&1
	  else
	    echo "/etc/inetd.conf 파일 존재하지 않음" >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  echo "■ /etc/xinetd.d 서비스" >> $CREATE_FILE 2>&1
  echo "-------------------------" >> $CREATE_FILE 2>&1
 
  if [ -d /etc/xinetd.d/ ]; then
 	 if [ `ls -alL /etc/xinetd.d/* | egrep $SERVICE_INETD | wc -l` -gt 0 ]
  	  then
  	    ls -alL /etc/xinetd.d/* | egrep $SERVICE_INETD  >> $CREATE_FILE 2>&1
  	  else
   	   echo "tftp, talk 서비스가 존재하지 않음" >> $CREATE_FILE 2>&1
  	fi
  fi

  echo " " >> $CREATE_FILE 2>&1
  echo "■ /etc/xinetd.d 내용 " >> $CREATE_FILE 2>&1
  echo "-----------------------" >> $CREATE_FILE 2>&1
 if [ -d /etc/xinetd.d ]; then
  if [ `ls -alL /etc/xinetd.d | egrep $SERVICE_INETD | wc -l` -gt 0 ]
    then
      for VVV in `ls -alL /etc/xinetd.d | egrep $SERVICE_INETD | grep -v "ssf" | awk '{print $9}'`
      do
        echo " $VVV 파일" >> $CREATE_FILE 2>&1
        cat /etc/xinetd.d/$VVV | grep -i "disable" >> $CREATE_FILE 2>&1
        echo "   " >> $CREATE_FILE 2>&1
      done
    else
      echo "xinetd.d 디렉터리에 tftp, talk, ntalk 파일이 없습니다" >> $CREATE_FILE 2>&1
  fi
 fi
  echo " " >> $CREATE_FILE 2>&1
  
  echo "■ tftp, talk, ntalk 프로세스 활성화 여부" >> $CREATE_FILE 2>&1
  echo "-------------------------------------- " >> $CREATE_FILE 2>&1

  if [ `ps -ef | egrep $SERVICE_INETD | grep -v grep | wc -l` -gt 0 ]
    then
      ps -ef | egrep $SERVICE_INETD | grep -v grep  >> $CREATE_FILE 2>&1
		echo ' ' >> service.ahnlab
	  echo "취약" >> service.ahnlab
    else
      echo "☞ tftp, talk, ntalk 프로세스가 실행중이지 않음" >> $CREATE_FILE 2>&1
	  echo "양호" >> service.ahnlab
  fi


  echo " " > service.ahnlab

  if [ -f /etc/inetd.conf ]
    then
      if [ `cat /etc/inetd.conf | grep -v '^ *#' | egrep $SERVICE_INETD | wc -l ` -eq 0 ]
        then
          echo "양호" >> service.ahnlab
        else
          echo "취약" >> service.ahnlab
      fi
    else
      echo "양호" >> service.ahnlab
  fi

  if [ -d /etc/xinetd.d ]
    then
      if [ `ls -alL /etc/xinetd.d | egrep $SERVICE_INETD | wc -l` -gt 0 ]
        then
          for VVV in `ls -alL /etc/xinetd.d | egrep $SERVICE_INETD | grep -v "ssf" | awk '{print $9}'`
          do
            if [ `cat /etc/xinetd.d/$VVV | grep -i "disable" | grep -i "no" | wc -l` -gt 0 ]
              then
                echo "취약" >> service.ahnlab
              else
                echo "양호" >> service.ahnlab
            fi
          done
        else
          echo "양호" >> service.ahnlab
      fi
    else
      echo "양호" >> service.ahnlab
  fi
  echo " " >> $CREATE_FILE 2>&1
	
  if [ `cat service.ahnlab | grep "취약" | wc -l` -eq 0 ]
    then
		echo "★ U_46. 결과 : 양호" >> $CREATE_FILE 2>&1
    else
		echo "★ U_46. 결과 : 취약" >> $CREATE_FILE 2>&1
  fi

  rm -rf service.ahnlab


  result="완료"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}

U_47() {
  echo -n "U_47. Sendmail 버전 점검  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_47. Sendmail 버전 점검 " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "▶ 점검기준 : Sendmail 버전이 8.13.8 이상인 경우 양호" >> $CREATE_FILE 2>&1
  echo "▶ 시스템 현황" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  echo "① Sendmail 프로세스 확인" >> $CREATE_FILE 2>&1
  echo "-------------------------------------- " >> $CREATE_FILE 2>&1
  if [ `ps -ef | grep sendmail | grep -v "grep" | wc -l` -eq 0 ]
    then
      echo "☞ Sendmail Service Disable" >> $CREATE_FILE 2>&1
    else
      ps -ef | grep sendmail | grep -v "grep" >> $CREATE_FILE 2>&1
      echo " " >> $CREATE_FILE 2>&1
   #   ls -al /etc/rc*.d/* | grep -i sendmail | grep "/S" >> $CREATE_FILE 2>&1
      echo " " >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1

  if [ -f /etc/mail/sendmail.cf ]
    then
	  echo "② /etc/mail/sendmail.cf 파일 내 버전 확인" >> $CREATE_FILE 2>&1
	  echo "-------------------------------------- " >> $CREATE_FILE 2>&1
      grep -v '^ *#' /etc/mail/sendmail.cf | grep DZ >> $CREATE_FILE 2>&1
  else if [ -f /etc/sendmail.cf ]
    then
	  echo "② /etc/sendmail.cf 파일 내 버전 확인" >> $CREATE_FILE 2>&1
	  grep -v '^ *#' /etc/sendmail.cf | grep DZ >> $CREATE_FILE 2>&1
  else
      echo "/etc/mail/sendmail.cf, /etc/sendmail.cf 파일 없음" >> $CREATE_FILE 2>&1
  fi
  fi

  echo " " >> $CREATE_FILE 2>&1
  
  if [ `ps -ef | grep sendmail | grep -v "grep" | wc -l` -eq 0 ]
    then
      echo "★ U_47. 결과 : 양호" >> $CREATE_FILE 2>&1
    else
      if [ -f /etc/mail/sendmail.cf ]
        then
          if [ `grep -v '^ *#' /etc/mail/sendmail.cf | grep -i dz | awk -F'.' '{print $2}'` -ge 14 ]
            then
					echo "★ U_47. 결과 : 양호" >> $CREATE_FILE 2>&1

        elif [ `grep -v '^ *#' /etc/mail/sendmail.cf | grep -i dz | awk -F'.' '{print $2}'` -eq 13 ]
				then
					if [ `grep -v '^ *#' /etc/mail/sendmail.cf | grep -i dz | awk -F'.' '{print $3}'` -ge 8 ]
						then
							echo "★ U_47. 결과 : 양호" >> $CREATE_FILE 2>&1
            		else
              			echo "★ U_47. 결과 : 취약" >> $CREATE_FILE 2>&1
          		fi
		
			fi
	   else if [ -f /etc/sendmail.cf ]
	     then
			  if [ `grep -v '^ *#' /etc/sendmail.cf | grep -i dz | awk -F'.' '{print $2}'` -ge 14 ]
            then
					echo "★ U_47. 결과 : 양호" >> $CREATE_FILE 2>&1

     	   elif [ `grep -v '^ *#' /etc/sendmail.cf | grep -i dz | awk -F'.' '{print $2}'` -eq 13 ]
				then
					if [ `grep -v '^ *#' /etc/sendmail.cf | grep -i dz | awk -F'.' '{print $3}'` -ge 8 ]
						then
				  			echo "★ U_47. 결과 : 양호" >> $CREATE_FILE 2>&1
            		else
              			echo "★ U_47. 결과 : 취약" >> $CREATE_FILE 2>&1
          		fi
		 	fi
       else
          echo "★ U_47. 결과 : 수동점검" >> $CREATE_FILE 2>&1
      fi
	 fi
  fi

  result="완료"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}



U_48() {
  echo -n "U_48. 스팸 메일 릴레이 제한  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_48. 스팸 메일 릴레이 제한 " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "▶ 점검기준 : SMTP 서비스를 사용하지 않거나 릴레이 제한이 설정되어 있는 경우 양호" >> $CREATE_FILE 2>&1
  echo "▶ 시스템 현황" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  echo "① Sendmail 프로세스 확인" >> $CREATE_FILE 2>&1
  echo "-------------------------------------- " >> $CREATE_FILE 2>&1
  if [ `ps -ef | grep sendmail | grep -v "grep" | wc -l` -eq 0 ]
    then
      echo "☞ Sendmail Service Disable" >> $CREATE_FILE 2>&1
    else
      ps -ef | grep sendmail | grep -v "grep" >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1



  echo " " >> $CREATE_FILE 2>&1

  echo "② /etc/mail/sendmail.cf 파일의 옵션 확인" >> $CREATE_FILE 2>&1
  echo "-------------------------------------- " >> $CREATE_FILE 2>&1
  if [ -f /etc/mail/sendmail.cf ]
    then
      cat /etc/mail/sendmail.cf | grep "R$\*" | grep "Relaying denied" >> $CREATE_FILE 2>&1
    else
      echo "/etc/mail/sendmail.cf 파일 없음" >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1

  if [ `ps -ef | grep sendmail | grep -v "grep" | wc -l` -eq 0 ]
    then
      echo "★ U_48. 결과 : 양호" >> $CREATE_FILE 2>&1
    else
      if [ -f /etc/mail/sendmail.cf ]
        then
          if [ `cat /etc/mail/sendmail.cf | grep -v "^#" | grep "R$\*" | grep -i "Relaying denied" | wc -l ` -gt 0 ]
            then
              echo "★ U_48. 결과 : 양호" >> $CREATE_FILE 2>&1
            else
              echo "★ U_48. 결과 : 취약" >> $CREATE_FILE 2>&1
          fi
        else
          echo "★ U_48. 결과 : 수동점검" >> $CREATE_FILE 2>&1
      fi
  fi


  result="완료"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_49() {
  echo -n "U_49. 일반사용자의 Sendmail 실행 방지  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_49. 일반사용자의 Sendmail 실행 방지 " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "▶ 점검기준 : SMTP 서비스 미사용 또는, 일반 사용자의 Sendmail 실행 방지가 설정 된 경우 양호(restrictqrun 옵션 확인)" >> $CREATE_FILE 2>&1
  echo "▶ 시스템 현황" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  echo "① Sendmail 프로세스 확인" >> $CREATE_FILE 2>&1
  echo "-------------------------------------- " >> $CREATE_FILE 2>&1
  if [ `ps -ef | grep sendmail | grep -v "grep" | wc -l` -eq 0 ]
    then
      echo "☞ Sendmail Service Disable" >> $CREATE_FILE 2>&1
    else
      ps -ef | grep sendmail | grep -v "grep" >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1



  echo " " >> $CREATE_FILE 2>&1

  echo "② /etc/mail/sendmail.cf 파일의 옵션 확인" >> $CREATE_FILE 2>&1
  echo "-------------------------------------- " >> $CREATE_FILE 2>&1
  if [ -f /etc/mail/sendmail.cf ]
    then
      grep -v '^ *#' /etc/mail/sendmail.cf | grep PrivacyOptions >> $CREATE_FILE 2>&1
    else
      echo "/etc/mail/sendmail.cf 파일 없음" >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1

  if [ `ps -ef | grep sendmail | grep -v "grep" | wc -l` -eq 0 ]
    then
      echo "★ U_49. 결과 : 양호" >> $CREATE_FILE 2>&1
    else
      if [ -f /etc/mail/sendmail.cf ]
        then
          if [ `cat /etc/mail/sendmail.cf | grep -i "restrictqrun" | grep -v "#" |wc -l ` -eq 1 ]
            then
              echo "★ U_49. 결과 : 양호" >> $CREATE_FILE 2>&1
            else
              echo "★ U_49. 결과 : 취약" >> $CREATE_FILE 2>&1
          fi
        else
          echo "★ U_49. 결과  : 수동점검" >> $CREATE_FILE 2>&1
      fi
  fi

  result="완료"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_50() {
  echo -n "U_50. DNS 보안 버전 패치  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_50. DNS 보안 버전 패치 " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "▶ 점검기준 : DNS 서비스를 사용하지 않거나 주기적으로 패치를 관리하고 있는 경우 양호" >> $CREATE_FILE 2>&1
  echo "▶ 영향버전 : BIND 9.0.x ~ 9.9.8, BIND 9.10.0 ~ 9.10.3"  >> $CREATE_FILE 2>&1
  echo "▶ 최신버전 : BIND 9.9.8-P2, 9.10.3-P2, 9.9.8-S3로 업데이트 " >> $CREATE_FILE 2>&1
  echo "▶ 시스템 현황" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  DNSPR=`ps -ef | egrep -i "/named|/in.named" | grep -v "grep" | awk 'BEGIN{ OFS="\n"} {i=1; while(i<=NF) {print $i; i++}}'| grep "/" | uniq`
  DNSPR=`echo $DNSPR | awk '{print $1}'`

  if [ `ps -ef | egrep -i "/named|/in.named" | grep -v grep | wc -l` -gt 0 ]
    then
      if [ -f $DNSPR ]
        then
          echo "BIND 버전 확인" >> $CREATE_FILE 2>&1
          echo "--------------" >> $CREATE_FILE 2>&1
          $DNSPR -v | grep BIND >> $CREATE_FILE 2>&1
        else
          echo "$DNSPR 파일 없음" >> $CREATE_FILE 2>&1
      fi
    else
      echo "☞ DNS Service Disable" >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1


  if [ `ps -ef | egrep -i "/named|/in.named" | grep -v "grep" | wc -l` -eq 0 ]
    then
      echo "★ U_50. 결과 : 양호" >> $CREATE_FILE 2>&1
    else
      if [ -f $DNSPR ]
        then
          if [ `$DNSPR -v | grep BIND | egrep '8.4.6 | 8.4.7 | 9.2.8-P1 | 9.3.4-P1 | 9.4.1-P1 | 9.5.0a6' | wc -l` -gt 0 ]
            then
              echo "★ U_50. 결과 : 양호" >> $CREATE_FILE 2>&1
            else
              echo "★ U_50. 결과 : 취약" >> $CREATE_FILE 2>&1
          fi
        else
          echo "★ U_50. 결과 : 수동점검" >> $CREATE_FILE 2>&1
      fi
  fi


  result="완료"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_51() {
  echo -n "U_51. DNS Zone Transfer 설정  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_51. DNS Zone Transfer 설정 " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "▶ 점검기준 : DNS 서비스 미사용 또는, Zone Transfer를 허가된 사용자에게만 허용한 경우 양호" >> $CREATE_FILE 2>&1
  echo "              allow-transfer 값에 none 또는 특정 IP를 설정 해주었는지 확인" >> $CREATE_FILE 2>&1
  echo "▶ 시스템 현황" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  echo "① DNS 프로세스 확인 " >> $CREATE_FILE 2>&1
  echo "-------------------------------------- " >> $CREATE_FILE 2>&1
  if [ `ps -ef | egrep -i "/named|/in.named" | grep -v "grep" | wc -l` -eq 0 ]
    then
      echo "☞ DNS Service Disable" >> $CREATE_FILE 2>&1
    else
      ps -ef | grep named | grep -v "grep" >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1

  #ls -al /etc/rc*.d/* | grep -i named | grep "/S" >> $CREATE_FILE 2>&1

  echo " " >> $CREATE_FILE 2>&1

  echo "② /etc/named.conf 파일의 allow-transfer 확인" >> $CREATE_FILE 2>&1
  echo "-------------------------------------- " >> $CREATE_FILE 2>&1
    if [ -f /etc/named.conf ]
      then
	    if [ `cat /etc/named.conf | grep -i 'allow-transfer' | wc -l` -eq 0 ]
		 then
		   echo "/etc/named.conf 파일 내 allow-transfer 설정 없음" >> $CREATE_FILE 2>&1
		 else
		   cat /etc/named.conf | grep 'allow-transfer' >> $CREATE_FILE 2>&1
	    fi
      else
        echo "/etc/named.conf 파일 없음" >> $CREATE_FILE 2>&1
   fi

  echo " " >> $CREATE_FILE 2>&1

  echo "③ /etc/named.boot 파일의 xfrnets 확인" >> $CREATE_FILE 2>&1
  echo "-------------------------------------- " >> $CREATE_FILE 2>&1
    if [ -f /etc/named.boot ]
      then
	    if [ `cat /etc/named.boot | grep "\xfrnets" | wc -l` -eq 0 ]
		 then
		   echo "/etc/named.boot 파일 내 xfrnets 설정 없음" >> $CREATE_FILE 2>&1
		 else
		   cat /etc/named.boot | grep "\xfrnets" >> $CREATE_FILE 2>&1
		fi
      else
        echo "/etc/named.boot 파일 없음" >> $CREATE_FILE 2>&1
    fi
	echo  " " >> $CREATE_FILE 2>&1
	
		
		 
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  if [ `ps -ef | egrep -i "/named|/in.named" | grep -v "grep" | wc -l` -eq 0 ]
    then
      echo "★ U_51. 결과 : 양호" >> $CREATE_FILE 2>&1
    else
      if [ -f /etc/named.conf ]
        then
          if [ `cat /etc/named.conf | egrep -i "\allow-transfer.*[0-256].[0-256].[0-256].[0-256].*|none" | grep -v "#" | wc -l` -eq 0 ]
            then
              echo "★ U_51. 결과 : 취약" >> $CREATE_FILE 2>&1
            else
              echo "★ U_51. 결과 : 양호" >> $CREATE_FILE 2>&1
          fi
        else
          if [ -f /etc/named.boot ]
            then
              if [ `cat /etc/named.boot | egrep -i "\xfrnets.*[0-256].[0-256].[0-256].[0-256].*|none" | grep -v "#" | wc -l` -eq 0 ]
                then
                  echo "★ U_51. 결과 : 취약" >> $CREATE_FILE 2>&1
                else
                  echo "★ U_51. 결과 : 양호" >> $CREATE_FILE 2>&1
              fi
           else
              echo "★ U_51. 결과 : 수동점검" >> $CREATE_FILE 2>&1
          fi
      fi
  fi

  result="완료"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_52() {
  echo -n "U_52. Apache 디렉터리 리스팅 제거  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_52. Apache 디렉터리 리스팅 제거 " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "▶ 점검기준 : 디렉터리 검색 기능을 사용하지 않는 경우 양호" >> $CREATE_FILE 2>&1
  echo "▶ 시스템 현황" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  if [ $web = 'httpd' ];then
		
		if [ `cat $conf |grep -i Indexes | grep -i -v '\-Indexes' | grep -v '\#'|wc -l` -eq 0 ]; then
			echo ' ' >> $CREATE_FILE 2>&1
			echo '☞ Indexes 옵션이 제거 되어 있음' >> $CREATE_FILE 2>&1
			echo ' ' >> $CREATE_FILE 2>&1
			echo "★ U_52. 결과 : 양호" >> $CREATE_FILE 2>&1
		else
			cat $conf |grep -i Indexes| grep -i -v '\-Indexes' | grep -v '\#' >> $CREATE_FILE 2>&1
			echo ' ' >> $CREATE_FILE 2>&1
			echo '☞ Indexes 옵션이 제거 되어 있지 않음' >> $CREATE_FILE 2>&1
			echo ' ' >> $CREATE_FILE 2>&1
			echo "★ U_52. 결과 : 취약" >> $CREATE_FILE 2>&1
		fi

  elif [ $web = 'apache2' ];then
	
		if [ `cat "$apache"sites-available/default |grep -i Indexes | grep -i -v '\-Indexes' | grep -v '\#'|wc -l` -eq 0 ]; then
			echo ' ' >> $CREATE_FILE 2>&1
			echo '☞ Indexes 옵션이 제거 되어 있음' >> $CREATE_FILE 2>&1
			echo ' ' >> $CREATE_FILE 2>&1
			echo "★ U_52. 결과 : 양호" >> $CREATE_FILE 2>&1
		else
			cat "$apache"sites-available/default |grep -i Indexes| grep -i -v '\-Indexes' | grep -v '\#' >> $CREATE_FILE 2>&1
			echo ' ' >> $CREATE_FILE 2>&1
			echo '☞ Indexes 옵션이 제거 되어 있지 않음' >> $CREATE_FILE 2>&1
			echo ' ' >> $CREATE_FILE 2>&1
			echo "★ U_52. 결과 : 취약" >> $CREATE_FILE 2>&1
		fi
  else
	echo '☞ 웹 서비스가 구동중이지 않음' >> $CREATE_FILE 2>&1
	echo ' ' >> $CREATE_FILE 2>&1
	echo "★ U_52. 결과 :  양호" >> $CREATE_FILE 2>&1
fi


  result="완료"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_53() {
  echo -n "U_53. Apache 웹 프로세스 권한 제한 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_53. Apache 웹 프로세스 권한 제한 " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "▶ 점검기준 : Apache 데몬이 root 권한으로 구동되지 않는 경우 양호" >> $CREATE_FILE 2>&1
  echo "▶ 시스템 현황" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  if [ $web = 'httpd' ];then
	if [ `ps -ef | grep httpd | grep -v grep | wc -l` -gt 0 ]; then
		if [ `ps -ef | grep httpd | grep -v grep | grep -v root | wc -l` -eq 0 ]; then
			ps -ef | grep httpd | grep -v grep | grep -v root >>  $CREATE_FILE 2>&1
			echo ' ' >>  $CREATE_FILE 2>&1
			echo '☞ root계정으로  Apache 서비스를 구동중' >> $CREATE_FILE 2>&1
			echo ' ' >> $CREATE_FILE 2>&1
			cat $conf | egrep "User |Group " | grep -v '#' >> $CREATE_FILE 2>&1
			echo ' ' >> $CREATE_FILE 2>&1
			echo "★ U_53. 결과 : 취약" >> $CREATE_FILE 2>&1
		else
			ps -ef | grep httpd | grep -v grep >>  $CREATE_FILE 2>&1
			echo ' ' >> $CREATE_FILE 2>&1
			echo '☞ root계정으로  Apache 서비스를 구동하지 않음' >> $CREATE_FILE 2>&1
			echo ' ' >> $CREATE_FILE 2>&1
			echo $conf'파일의 설정 내용' >> $CREATE_FILE 2>&1
			echo '------------------------' >> $CREATE_FILE 2>&1
			cat $conf | egrep "User |Group " | grep -v '#' >> $CREATE_FILE 2>&1
			echo '------------------------' >> $CREATE_FILE 2>&1
			echo ' ' >> $CREATE_FILE 2>&1
			echo "★ U_53. 결과 : 양호" >> $CREATE_FILE 2>&1
		fi
	fi

elif [ $web = 'apache2' ];then
	if [ `ps -ef | grep apache2 | grep -v grep | wc -l` -gt 0 ]; then
		if [ `ps -ef | grep apache2 | grep -v grep | grep -v root | wc -l` -eq 0 ]; then
			ps -ef | grep apache2 | grep -v grep | grep -v root >>  $CREATE_FILE 2>&1
			echo ' ' >>  $CREATE_FILE 2>&1
			echo '☞ root계정으로  Apache 서비스를 구동중' >> $CREATE_FILE 2>&1
			echo ' ' >> $CREATE_FILE 2>&1
			cat $conf | egrep "User |Group " | grep -v '#' >> $CREATE_FILE 2>&1
			echo ' ' >> $CREATE_FILE 2>&1
			echo "★ U_53. 결과 : 취약" >> $CREATE_FILE 2>&1
		else
			ps -ef | grep apache2 | grep -v grep >>  $CREATE_FILE 2>&1
			echo ' ' >> $CREATE_FILE 2>&1
			echo '☞ root계정으로  Apache 서비스를 구동하지 않음' >> $CREATE_FILE 2>&1
			echo ' ' >> $CREATE_FILE 2>&1
			echo $conf'파일의 설정 내용' >> $CREATE_FILE 2>&1
			echo '------------------------' >> $CREATE_FILE 2>&1
			cat $conf | egrep "User |Group " | grep -v '#' >> $CREATE_FILE 2>&1
			echo '------------------------' >> $CREATE_FILE 2>&1
			echo ' ' >> $CREATE_FILE 2>&1
			echo "★ U_53. 결과 : 양호" >> $CREATE_FILE 2>&1
		fi
	fi
else
	echo '☞ 웹 서비스가 구동중이지 않음' >> $CREATE_FILE 2>&1
	echo ' ' >> $CREATE_FILE 2>&1
	echo "★ U_52. 결과 :  양호" >> $CREATE_FILE 2>&1	
fi
  result="완료"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_54() {
  echo -n "U_54. Apache 상위 디렉터리 접근 금지 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_54. Apache 상위 디렉터리 접근 금지 " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "▶ 점검기준 : 상위 디렉터리에 이동 제한을 설정한 경우 양호" >> $CREATE_FILE 2>&1
  echo "▶ 시스템 현황" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  if [ $web = 'httpd' ];then
	if [ `cat $conf | grep -i 'AllowOverride' | grep -v '#' | grep -i "None" | wc -l` -eq 0 ];then
		echo '☞ AuthConfig 옵션 설정되어 있음'>> $CREATE_FILE 2>&1
		echo ' ' >>  $CREATE_FILE 2>&1
		echo "★ U_54. 결과 : 양호" >> $CREATE_FILE 2>&1
	else
		cat $conf| grep -i 'AllowOverride' | grep -v '#' >> $CREATE_FILE 2>&1
		echo ' ' >> $CREATE_FILE 2>&1
		echo '☞ AuthConfig 옵션 설정되어 있지 않음' >> $CREATE_FILE 2>&1
		echo ' ' >>  $CREATE_FILE 2>&1
		echo "★ U_54. 결과 : 취약" >> $CREATE_FILE 2>&1
	fi

  elif [ $web = 'apache2' ];then
	if [ `cat "$apache"sites-available/default |grep AllowOverride| grep -v '#'| grep -i "None" | wc -l` -eq 0 ];then
	    cat "$apache"sites-available/default |grep AllowOverride|grep -v '\#' >> $CREATE_FILE 2>&1
			echo ' ' >> $CREATE_FILE 2>&1
			echo '☞ AuthConfig 옵션 설정되어 있음' >>$CREATE_FILE 2>&1
			echo ' ' >>  $CREATE_FILE 2>&1
			echo "★ U_54. 결과 : 양호" >> $CREATE_FILE 2>&1
		else
			cat "$apache"sites-available/default |grep AllowOverride|grep -v '\#' >> $CREATE_FILE 2>&1
			echo ' ' >> $CREATE_FILE 2>&1
			echo '☞ AuthConfig 옵션 설정되어 있지 않음' >>$CREATE_FILE 2>&1
			echo ' ' >>  $CREATE_FILE 2>&1
			echo "★ U_54. 결과 : 취약" >> $CREATE_FILE 2>&1
	fi
 else
	echo '☞ 웹 서비스가 구동중이지 않음' >> $CREATE_FILE 2>&1
	echo ' ' >> $CREATE_FILE 2>&1
    echo "★ U_52. 결과 :  양호" >> $CREATE_FILE 2>&1
  fi
  result="완료"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_55() {
  echo -n "U_55. Apache 불필요한 파일 제거 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_55. Apache 불필요한 파일 제거 " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "▶ 점검기준 : 메뉴얼 파일 및 디렉터리가 제거되어 있는 경우 양호" >> $CREATE_FILE 2>&1
  echo "▶ 시스템 현황" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

if [ `ps -ef | egrep "httpd|apache2" | grep -v grep | wc -l` -ge 1 ]
then
	if [ -d "$docroot"/../ ]; then
	  	if [ `ls -l "$docroot"/../ | grep 'manual' |wc -l` -eq 0 ]; then
			echo '☞ Manual 디렉토리가 존재하지 않음' >> $CREATE_FILE 2>&1
			echo ' ' >>  $CREATE_FILE 2>&1
			echo "★ U_55. 결과 : 양호" >> $CREATE_FILE 2>&1
	
 		else
			ls -l "$docroot"/../ | grep 'manual' >> $CREATE_FILE 2>&1
			echo ' ' >> $CREATE_FILE 2>&1
			echo '☞ Manual 디렉토리가  존재함' >>  $CREATE_FILE 2>&1
			echo ' ' >>  $CREATE_FILE 2>&1
			echo "★ U_55. 결과 : 취약" >> $CREATE_FILE 2>&1
		fi
	fi
	if [ -d "$docroot"/../htdocs/ ]; then 
		if [ `ls -l "$docroot"/../htdocs/ | grep 'manual' |wc -l` -eq 0 ]; then
			echo '☞ Manual 디렉토리가 존재하지 않음' >> $CREATE_FILE 2>&1
			echo ' ' >>  $CREATE_FILE 2>&1
			echo "★ U_55. 결과 : 양호" >> $CREATE_FILE 2>&1
	
 		else
			ls -l "$docroot"/../htdocs/ | grep 'manual' >> $CREATE_FILE 2>&1
			echo ' ' >>  $CREATE_FILE 2>&1
			echo '☞ Manual 디렉토리가  존재함' >>  $CREATE_FILE 2>&1
			echo ' ' >>  $CREATE_FILE 2>&1
			echo "★ U_55. 결과 : 취약" >> $CREATE_FILE 2>&1
		fi
	fi
   echo " " >> $CREATE_FILE 2>&1
else  
   echo '☞ 웹 서비스가 구동중이지 않음' >> $CREATE_FILE 2>&1
	echo ' ' >> $CREATE_FILE 2>&1
    echo "★ U_52. 결과 :  양호" >> $CREATE_FILE 2>&1
fi
  result="완료"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_56() {
  echo -n "U_56. Apache 링크 사용금지 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_56. Apache 링크 사용금지 " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "▶ 점검기준 : 심볼릭 링크, aliases 사용을 제한한 경우 양호" >> $CREATE_FILE 2>&1
  echo "▶ 시스템 현황" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  if [ $web = 'httpd' ];then
	if [ `cat $conf | grep -i 'FollowSymLinks' | grep -i -v '\-FollowSymLinks' | grep -v '#' | wc -l` -eq 0 ];then
		echo '☞ Apache 링크 사용 설정값이 존재하지 않음' >> $CREATE_FILE 2>&1
		echo ' ' >>  $CREATE_FILE 2>&1
		echo "★ U_56. 결과 : 양호" >> $CREATE_FILE 2>&1
	else
		cat  $conf | grep -i 'FollowSymLinks' | grep -i -v '\-FollowSymLinks' | grep -v '\#' >> $CREATE_FILE 2>&1
		echo ' ' >> $CREATE_FILE 2>&1
		echo '☞ Apache 링크 사용 설정값이 존재' >> $CREATE_FILE 2>&1
		echo ' ' >>  $CREATE_FILE 2>&1
		echo "★ U_56. 결과 : 취약" >> $CREATE_FILE 2>&1
	fi
  elif [ $web = 'apache2' ];then
	if [ `cat "$apache"sites-available/default | grep -i 'FollowSymLinks'| grep -i -v '\-FollowSymLinks' | grep -v '#'| wc -l` -eq 0 ]; then
			echo ' ' >> $CREATE_FILE 2>&1
			echo '☞ Apache 링크 사용 설정값이 존재하지 않음' >> $CREATE_FILE 2>&1
			echo ' ' >>  $CREATE_FILE 2>&1
			echo "★ U_56. 결과 : 양호" >> $CREATE_FILE 2>&1
		else
			cat "$apache"sites-available/default |grep -i 'FollowSymLinks' | grep -i -v '\FollowSymLinks' | grep -v '\#' >> $CREATE_FILE 2>&1
			echo ' ' >> $CREATE_FILE 2>&1
			echo '☞ Apache 링크 사용 설정값이 존재' >> $CREATE_FILE 2>&1
			echo ' ' >>  $CREATE_FILE 2>&1
			echo "★ U_56. 결과 : 취약" >> $CREATE_FILE 2>&1
	fi
  
  echo " " >> $CREATE_FILE 2>&1  
  else
	echo '☞ 웹 서비스가 구동중이지 않음' >> $CREATE_FILE 2>&1
	echo ' ' >> $CREATE_FILE 2>&1
  	echo "★ U_52. 결과 :  양호" >> $CREATE_FILE 2>&1
  fi 
  


  result="완료"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_57() {
  echo -n "U_57. Apache 파일 업로드 및 다운로드 제한 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_57. Apache 파일 업로드 및 다운로드 제한 " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "▶ 점검기준 : 파일 업로드 및 다운로드를 제한한 경우 양호" >> $CREATE_FILE 2>&1
  echo "▶ 시스템 현황" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  if [ $web = 'httpd' ];then
	
	if [ `cat $conf | grep -i LimitRequestBody | grep -v "#" | wc -l` -eq 0 ];then
		
		echo '☞ 파일 업로드 및 다운로드 제한 설정값 없음' >> $CREATE_FILE 2>&1
		echo ' ' >>  $CREATE_FILE 2>&1
		echo "★ U_57. 결과 : 취약" >> $CREATE_FILE 2>&1
		
	else
		cat $conf | grep -i 'LimitRequestBody' >> $CREATE_FILE 2>&1
		
		echo '☞ 파일 업로드 및 다운로드 제한 설정됨' >> $CREATE_FILE 2>&1
		echo ' ' >>  $CREATE_FILE 2>&1
		echo "★ U_57. 결과 : 양호" >> $CREATE_FILE 2>&1
		
	fi
   elif [ $web = 'apache2' ];then
	if [ `cat "$apache"sites-available/default |grep LimitRequestBody| grep -v '#'| wc -l` -eq 0 ]; then
			
			echo '☞ 파일 업로드 및 다운로드 제한 설정값 없음' >> $CREATE_FILE 2>&1
			echo ' ' >>  $CREATE_FILE 2>&1
			echo "★ U_57. 결과 : 수동점검" >> $CREATE_FILE 2>&1
		else
			cat "$apache"sites-available/default |grep LimitRequestBody|grep -v '#' >> $CREATE_FILE 2>&1
			
			echo '☞ Apache 링크 사용 설정값이 존재' >> $CREATE_FILE 2>&1
			echo ' ' >>  $CREATE_FILE 2>&1
			echo "★ U_57. 결과 : 양호" >> $CREATE_FILE 2>&1
	fi
  
  echo " " >> $CREATE_FILE 2>&1
  else 
	echo '☞ 웹 서비스가 구동중이지 않음' >> $CREATE_FILE 2>&1
	echo ' ' >> $CREATE_FILE 2>&1
  	echo "★ U_52. 결과 :  양호" >> $CREATE_FILE 2>&1
  fi
  result="완료"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_58() {
  echo -n "U_58. Apache 웹 서비스 영역의 분리 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_58. Apache 웹 서비스 영역의 분리 " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "▶ 점검기준 : DocumentRoot를 별도의 디렉터리로 지정한 경우 양호" >> $CREATE_FILE 2>&1
  echo "              기본 경로(/usr/local/apache/htdocs, /usr/local/apache2/htdocs, /var/www/html, /opt/hpws/apache/htdocs 등)사용 여부 확인" >> $CREATE_FILE 2>&1
  echo "▶ 시스템 현황" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  
  dir="/usr/local/apache/htdocs /usr/local/apache2/htdocs /var/www/html /opt/hpws/apache/htdocs"
  

if [ $web = 'httpd' ];then
  if [ -f $conf ]
	then
		echo '☞ Apache DocumentRoot 경로' >> $CREATE_FILE 2>&1
		echo ' ' >> $CREATE_FILE 2>&1
		cat $conf | grep -i 'DocumentRoot'  | grep -v '#'>> $CREATE_FILE 2>&1
		echo ' ' >> $CREATE_FILE 2>&1
		for d in $dir
		do
			if [ `cat "$conf" | grep -i 'DocumentRoot' | grep -v '#' | grep -i "$d" | wc -l` -eq 0 ]
			then
				echo "양호" >> webdir.ahnlab
			else
				echo "취약" >> webdir.ahnlab
			fi
		done
   fi
   if [ `cat webdir.ahnlab | grep "취약" | wc -l` -gt 0 ]
    then
	  echo "☞ 기본경로 사용중" >> $CREATE_FILE 2>&1
	  echo " " >> $CREATE_FILE 2>&1	
      echo "★ U_58. 결과 : 취약" >> $CREATE_FILE 2>&1
    else
      echo "★ U_58. 결과 : 양호" >> $CREATE_FILE 2>&1
  fi
  rm -rf webdir.ahnlab
   
elif [ $web = 'apache2' ];then
	 if [ -d $apache ]
	  then		
		echo '☞ Apache DocumentRoot 경로' >> $CREATE_FILE 2>&1
		echo ' ' >> $CREATE_FILE 2>&1
		cat "$apache"sites-available/default | grep -i 'DocumentRoot'  | grep -v '#'>> $CREATE_FILE 2>&1
		echo ' ' >> $CREATE_FILE 2>&1
		for d in $dir
		do
			if [ `cat "$conf" | grep -i 'DocumentRoot' | grep -v '#' | grep -i "$d" | wc -l` -eq 0 ]
			then
				echo "양호" >> webdir.ahnlab
			else
				echo "취약" >> webdir.ahnlab
			fi
		done
	fi
	if [ `cat webdir.ahnlab | grep "취약" | wc -l` -gt 0 ]
    then
	  echo "☞ 기본경로 사용중" >> $CREATE_FILE 2>&1
	  echo " " >> $CREATE_FILE 2>&1	
      echo "★ U_58. 결과 : 취약" >> $CREATE_FILE 2>&1
    else
      echo "★ U_58. 결과 : 양호" >> $CREATE_FILE 2>&1
	fi
else
		echo '☞ 웹 서비스가 구동중이지 않음' >> $CREATE_FILE 2>&1
		echo ' ' >> $CREATE_FILE 2>&1
		echo "★ U_52. 결과 :  양호" >> $CREATE_FILE 2>&1
fi  
  echo " " >> $CREATE_FILE 2>&1
  
  result="완료"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_59() {
  echo -n "U_59. ssh 원격접속 허용 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_59. ssh 원격접속 허용 " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "▶ 점검기준 : 원격 접속 시 SSH 프로토콜을 사용하는 경우 양호" >> $CREATE_FILE 2>&1
  echo "▶ 시스템 현황" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  echo "① 프로세스 데몬 동작 확인" >> $CREATE_FILE 2>&1
  echo "------------------------------------------------------------------------------" >> $CREATE_FILE 2>&1

  if [ `ps -ef | grep sshd | grep -v "grep" | wc -l` -eq 0 ]
	  then
		  echo "☞ SSH Service Disable" >> $CREATE_FILE 2>&1
	  else
		  ps -ef | grep sshd | grep -v "grep" >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1

  echo "② 서비스 포트 확인" >> $CREATE_FILE 2>&1
  echo "------------------------------------------------------------------------------" >> $CREATE_FILE 2>&1

  echo " " > ssh-result.ahnlab

  ServiceDIR="/etc/sshd_config /etc/ssh/sshd_config /usr/local/etc/sshd_config /usr/local/sshd/etc/sshd_config /usr/local/ssh/etc/sshd_config /etc/opt/ssh/sshd_config"

  for file in $ServiceDIR
    do
	    if [ -f $file ]
	      then
		      if [ `cat $file | grep "^Port" | grep -v "^#" | wc -l` -gt 0 ]
		        then
			        cat $file | grep "^Port" | grep -v "^#" | awk '{print "SSH 설정파일('${file}'): " $0 }' >> ssh-result.ahnlab
			        port1=`cat $file | grep "^Port" | grep -v "^#" | awk '{print $2}'`
			        echo " " > port1-search.ahnlab
		        else
			        echo "SSH 설정파일($file): 포트 설정 X (Default 설정: 22포트 사용)" >> ssh-result.ahnlab
		      fi
	    fi
    done

  if [ `cat ssh-result.ahnlab | grep -v "^ *$" | wc -l` -gt 0 ]
    then
	    cat ssh-result.ahnlab | grep -v "^ *$" >> $CREATE_FILE 2>&1
    else
	    echo "SSH 설정파일: 설정 파일을 찾을 수 없습니다." >> $CREATE_FILE 2>&1
  fi
  
  echo " " >> $CREATE_FILE 2>&1

  # 서비스 포트 점검
  echo "③ 서비스 포트 활성화 여부 확인" >> $CREATE_FILE 2>&1
  echo "------------------------------------------------------------------------------" >> $CREATE_FILE 2>&1

  if [ -f port1-search.ahnlab ]
    then
	    if [ `netstat -nat | grep ":$port1 " | grep -i "^tcp" | grep -i "LISTEN" | wc -l` -eq 0 ]
	      then
		      echo "☞ SSH Service Disable" >> $CREATE_FILE 2>&1
	      else
		      netstat -na | grep ":$port1 " | grep -i "^tcp" | grep -i "LISTEN" >> $CREATE_FILE 2>&1
	    fi
    else
	    if [ `netstat -nat | grep ":22 " | grep -i "^tcp" | grep -i "LISTEN" | wc -l` -eq 0 ]
	      then
		      echo "☞ SSH Service Disable" >> $CREATE_FILE 2>&1
	      else
		      netstat -nat | grep ":22 " | grep -i "^tcp" | grep -i "LISTEN" >> $CREATE_FILE 2>&1
	    fi
  fi

  echo " " >> $CREATE_FILE 2>&1

  if [ -f port1-search.ahnlab ]
    then
      if [ `netstat -nat | grep ":$port1 " | grep -i "^tcp" | grep -i "LISTEN" | wc -l` -eq 0 ]
        then
          echo "★ U_59. 결과 : 취약" >> $CREATE_FILE 2>&1
        else
          echo "★ U_59. 결과 : 양호" >> $CREATE_FILE 2>&1
      fi
    else
	    if [ `netstat -nat | grep ":22 " | grep -i "^tcp" | grep -i "LISTEN" | wc -l` -eq 0 ]
	      then
	        echo "★ U_59. 결과 : 취약" >> $CREATE_FILE 2>&1
	      else
	        echo "★ U_59. 결과 : 양호" >> $CREATE_FILE 2>&1
	    fi
	fi


  rm -rf ssh-result.ahnlab port1-search.ahnlab

  result="완료"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_60() {
  echo -n "U_60. ftp 서비스 확인 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_60. ftp 서비스 확인 " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "▶ 점검기준 : FTP 서비스가 비활성화 되어 있는 경우 양호" >> $CREATE_FILE 2>&1
  echo "▶ 시스템 현황" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  find /etc -name "proftpd.conf" > proftpd.ahnlab
  find /etc -name "vsftpd.conf" > vsftpd.ahnlab
  profile=`cat proftpd.ahnlab`
  vsfile=`cat vsftpd.ahnlab`

  echo "① /etc/services 파일에서 포트 확인" >> $CREATE_FILE 2>&1
  echo "------------------------------------------------------------------------------" >> $CREATE_FILE 2>&1

  if [ `cat /etc/services | awk -F" " '$1=="ftp" {print "(1)/etc/service파일:" $1 " " $2}' | grep "tcp" | wc -l` -gt 0 ]
    then
	    cat /etc/services | awk -F" " '$1=="ftp" {print "(1)/etc/service파일:" $1 " " $2}' | grep "tcp" >> $CREATE_FILE 2>&1
    else
	    echo "(1)/etc/service파일: 포트 설정 X (Default 21번 포트)" >> $CREATE_FILE 2>&1
  fi

  if [ -s vsftpd.ahnlab ]
    then
	    if [ `cat $vsfile | grep "listen_port" | grep -v "^#" | awk '{print "(3)VsFTP 포트: " $1 "  " $2}' | wc -l` -gt 0 ]
	      then
		      cat $vsfile | grep "listen_port" | grep -v "^#" | awk '{print "(3)VsFTP 포트: " $1 "  " $2}' >> $CREATE_FILE 2>&1
	      else
		      echo "(2)VsFTP 포트: 포트 설정 X (Default 21번 포트 사용중)" >> $CREATE_FILE 2>&1
	    fi
    else
	    echo "(2)VsFTP 포트: VsFTP가 설치되어 있지 않습니다." >> $CREATE_FILE 2>&1
  fi


  if [ -s proftpd.ahnlab ]
    then
	    if [ `cat $profile | grep "Port" | grep -v "^#" | awk '{print "(2)ProFTP 포트: " $1 "  " $2}' | wc -l` -gt 0 ]
	      then
		      cat $profile | grep "Port" | grep -v "^#" | awk '{print "(2)ProFTP 포트: " $1 "  " $2}' >> $CREATE_FILE 2>&1
	      else
		      echo "(3)ProFTP 포트: 포트 설정 X (/etc/service 파일에 설정된 포트 사용중)" >> $CREATE_FILE 2>&1
	    fi
    else
	    echo "(3)ProFTP 포트: ProFTP가 설치되어 있지 않습니다." >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1

  echo "② 서비스 포트 활성화 여부 확인" >> $CREATE_FILE 2>&1
  echo "------------------------------------------------------------------------------" >> $CREATE_FILE 2>&1

  ################# /etc/services 파일에서 포트 확인 #################

  if [ `cat /etc/services | awk -F" " '$1=="ftp" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
    then
	    port=`cat /etc/services | awk -F" " '$1=="ftp" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	    
	    if [ `netstat -nat | grep ":$port " | grep -i "^tcp" | grep -i "LISTEN" | wc -l` -gt 0 ]
	      then
		      netstat -nat | grep ":$port " | grep -i "^tcp" | grep -i "LISTEN" >> $CREATE_FILE 2>&1
		      echo "ftp enable" > ftpenable.ahnlab
	    fi
    else
	    netstat -nat | grep ":21 " | grep -i "^tcp" | grep -i "LISTEN" >> $CREATE_FILE 2>&1
	    echo "ftp enable" > ftpenable.ahnlab
  fi

  ################# vsftpd 에서 포트 확인 ############################

  if [ -s vsftpd.ahnlab ]
    then
	    if [ `cat $vsfile | grep "listen_port" | grep -v "^#" | awk -F"=" '{print $2}' | wc -l` -eq 0 ]
	      then
		      port=21
	      else
		      port=`cat $vsfile | grep "listen_port" | grep -v "^#" | awk -F"=" '{print $2}'`
	    fi
	    if [ `netstat -nat | grep ":$port " | grep -i "^tcp" | grep -i "LISTEN" | wc -l` -gt 0 ]
	      then
		      netstat -nat | grep ":$port " | grep -i "^tcp" | grep -i "LISTEN" >> $CREATE_FILE 2>&1
		      echo "ftp Service Enable" >> ftpenable.ahnlab
	    fi
	  else
	    echo "ftp Service Disable" >> ftpenable.ahnlab
  fi

  ################# proftpd 에서 포트 확인 ###########################

  if [ -s proftpd.ahnlab ]
    then
	    port=`cat $profile | grep "Port" | grep -v "^#" | awk '{print $2}'`
	    
	    if [ `netstat -nat | grep ":$port " | grep -i "^tcp" | grep -i "LISTEN" | wc -l` -gt 0 ]
	      then
		      netstat -nat | grep ":$port " | grep -i "^tcp" | grep -i "LISTEN" >> $CREATE_FILE 2>&1
				echo " " >> $CREATE_FILE 2>&1
				echo "ftp Service Enable" >> $CREATE_FILE 2>&1 
		      echo "ftp Service Enable"  >> ftpenable.ahnlab
		    else
				echo " " >> $CREATE_FILE 2>&1
				echo "ftp Service Disable" >> $CREATE_FILE 2>&1
		      echo "ftp Service Disable" >> ftpenable.ahnlab
	    fi
	  else
	    echo "ftp disable" >> ftpenable.ahnlab
  fi
	echo " " >> $CREATE_FILE 2>&1
	echo "③서비스 활성화 확인" >> $CREATE_FILE 2>&1
	echo "------------------------------------------------------------------------------" >> $CREATE_FILE 2>&1
	if [ `ps -ef | grep ftp | grep -v grep | wc -l` -eq 0 ]
	then
		echo ' ' >> $CREATE_FILE 2>&1
		echo "☞ ftp Service Disable" >> $CREATE_FILE 2>&1
	else
		echo ' ' >> $CREATE_FILE 2>&1
		echo "☞ ftp Service Enable" >> $CREATE_FILE 2>&1
	fi

  echo " " >> $CREATE_FILE 2>&1

  if [ `cat ftpenable.ahnlab | grep "enable" | wc -l` -gt 0 ]
    then
      echo "★ U_60. 결과 : 취약" >> $CREATE_FILE 2>&1
    else
      echo "★ U_60. 결과 : 양호" >> $CREATE_FILE 2>&1
  fi

  rm -rf proftpd.ahnlab vsftpd.ahnlab


  result="완료"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_61() {
  echo -n "U_61. ftp 계정 shell 제한 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_61. ftp 계정 shell 제한 " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "▶ 점검기준 : ftp 계정에 /bin/fasle 쉘이 부여되어 있는 경우 양호" >> $CREATE_FILE 2>&1
  echo "▶ 시스템 현황" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
if [ `ps -ef | grep -i ftp | grep -v grep | wc -l` -gt 0 ]
    then
		echo "☞ FTP Service Enable" >> $CREATE_FILE 2>&1
		echo " " >> $CREATE_FILE 2>&1
  echo "① ftp 계정 쉘 확인(ftp 계정에 false 또는 nologin 설정시 양호)" >> $CREATE_FILE 2>&1
  echo "------------------------------------------------------------------------------" >> $CREATE_FILE 2>&1

  if [ `cat /etc/passwd | awk -F: '$1=="ftp"' | wc -l` -gt 0 ]
    then
	    cat /etc/passwd | awk -F: '$1=="ftp"' >> $CREATE_FILE 2>&1
		echo " " >> $CREATE_FILE 2>&1
			if [ `cat /etc/passwd | awk -F: '$1=="ftp"' | egrep "false|nologin" | wc -l` -gt 0 ]
	   	 then
		 	   echo "★ U_61. 결과 : 양호" >> $CREATE_FILE 2>&1
	  		 else
   			   echo "★ U_61. 결과 : 취약" >> $CREATE_FILE 2>&1
  			fi
   else
	   echo "ftp 계정이 존재하지 않음." >> $CREATE_FILE 2>&1
	   echo " " >> $CREATE_FILE 2>&1
	   echo "★ U_61. 결과 : 양호" >> $CREATE_FILE 2>&1
  fi
else
	echo "☞ ftp Service Disable" >> $CREATE_FILE 2>&1
	echo " " >> $CREATE_FILE 2>&1
	echo "★ U_61. 결과 : 양호" >> $CREATE_FILE 2>&1
fi
  echo " " >> $CREATE_FILE 2>&1

  result="완료"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_62() {
  echo -n "U_62. Ftpusers 파일 소유자 및 권한 설정 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_62. Ftpusers 파일 소유자 및 권한 설정 " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "▶ 점검기준 : ftpusers 파일의 소유자가 root이고, 권한이 640 이하인 경우 양호" >> $CREATE_FILE 2>&1
  echo "▶ 시스템 현황" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo " " > ftpusers.ahnlab
if [ `ps -ef | grep -i ftp | grep -v grep | wc -l` -gt 0 ]
    then
		echo "☞ FTP Service Enable" >> $CREATE_FILE 2>&1
		echo " " >> $CREATE_FILE 2>&1
  if [ -f /etc/ftpd/ftpusers ]
    then
      ls -alL /etc/ftpd/ftpusers  >> $CREATE_FILE 2>&1
		if [ `ls -alL /etc/ftpd/ftpusers | awk '{print $1}' | grep '.....-----' | wc -l` -eq 0 ]
        then
          echo "취약" >> ftpusers.ahnlab
        else
          echo "양호" >> ftpusers.ahnlab
     fi
    else
      echo " /etc/ftpd/ftpusers 파일이 없습니다."  >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1

  if [ -f /etc/ftpusers ]
    then
      ls -alL /etc/ftpusers  >> $CREATE_FILE 2>&1
		if [ `ls -alL /etc/ftpusers | awk '{print $1}' | grep '.....-----'| wc -l` -eq 0 ]
        then
          echo "취약" >> ftpusers.ahnlab
        else
          echo "양호" >> ftpusers.ahnlab
      fi
    else
      echo " /etc/ftpusers 파일이 없습니다."  >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1
	if [ -f /etc/vsftpd.ftpusers ]
    then
      ls -alL /etc/vsftpd.ftpusers  >> $CREATE_FILE 2>&1
		if [ `ls -alL /etc/vsftpd.ftpusers | awk '{print $1}' | grep '.....-----' | wc -l` -eq 0 ]
			then
				echo "취약" >> ftpusers.ahnlab
      	else
       	   echo "양호" >> ftpusers.ahnlab
      fi
	else
		echo " /etc/vsftpd.ftpusers 파일이 없습니다."  >> $CREATE_FILE 2>&1
	fi
	echo " " >> $CREATE_FILE 2>&1
	
	if [ -f /etc/vsftpd/ftpusers ]
		then
			ls -alL /etc/vsftpd/ftpusers  >> $CREATE_FILE 2>&1
			if [ `ls -alL /etc/vsftpd/ftpusers | awk '{print $1}' | grep '.....-----' | wc -l` -eq 0 ]
       	 then
      	    echo "취약" >> ftpusers.ahnlab
        	else
        	  echo "양호" >> ftpusers.ahnlab
				
      	fi
	else
      echo " /etc/vsftpd/ftpusers 파일이 없습니다."  >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1

	if [ -f /etc/vsftpd.user_list ]
   then
      ls -alL /etc/vsftpd.user_list >> $CREATE_FILE 2>&1
		if [ `ls -alL /etc/vsftpd.user_list | awk '{print $1}' | grep '.....-----' | wc -l` -eq 0 ]
				then
					echo "취약" >> ftpusers.ahnlab
        	else
					echo "양호" >> ftpusers.ahnlab
      fi
	else
		echo " /etc/vsftpd.user_list 파일이 없습니다."  >> $CREATE_FILE 2>&1
 	fi 

	echo " " >> $CREATE_FILE 2>&1

	if [ -f /etc/vsftpd/user_list ]
	then
		ls -alL /etc/vsftpd/user_list >> $CREATE_FILE 2>&1
		if [ `ls -alL /etc/vsftpd/user_list | awk '{print $1}' | grep '.....-----' | wc -l` -eq 0 ]
        then
          echo "취약" >> ftpusers.ahnlab
      else
          echo "양호" >> ftpusers.ahnlab
		fi
	else
      
		echo " " >> $CREATE_FILE 2>&1
		echo " /etc/vsftpd/user_list 파일이 없습니다."  >> $CREATE_FILE 2>&1
  fi
else
	echo "☞ ftp Service Disable" >> $CREATE_FILE 2>&1
	echo " " >> $CREATE_FILE 2>&1
fi

  
  

	
  if [ `cat ftpusers.ahnlab | grep "취약" | wc -l` -gt 0 ]
    then
      echo "★ U_62. 결과 : 취약" >> $CREATE_FILE 2>&1
    else
      echo "★ U_62. 결과 : 양호" >> $CREATE_FILE 2>&1
  fi

  rm -rf ftpusers.ahnlab


  result="완료"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_63() {
  echo -n "U_63. Ftpusers 파일 설정 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_63. Ftpusers 파일 설정 " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "▶ 점검기준 : FTP 서비스가 비활성화 되어 있거나, 활성화 시 root 계정 접속을 차단한 경우 양호" >> $CREATE_FILE 2>&1
  echo "▶ 시스템 현황" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  if [ `cat ftpenable.ahnlab | grep "enable" | wc -l` -gt 0 ]
    then
		echo "☞ FTP Service Enable" >> $CREATE_FILE 2>&1
		echo " " >> $CREATE_FILE 2>&1
		if [ -f /etc/ftpd/ftpusers ]
        then
			echo "/etc/ftpd/ftpusers 파일존재" >> $CREATE_FILE 2>&1
			echo "/etc/ftpd/ftpusers 내용" >>$CREATE_FILE 2>&1
			 
			 if [ `cat /etc/ftpd/ftpusers | grep root | grep -v '#' | wc -l` -eq 1 ]
			 then
					cat /etc/ftpd/ftpusers | grep root | grep -v '#' >>$CREATE_FILE 2>&1
					echo "☞root 계정 접속 차단됨" >> $CREATE_FILE 2>&1
					cat /etc/ftpd/ftpusers | grep root >> ftp.ahnlab 2>&1
			else
				echo "☞root 계정 접속 차단되지 않음" >> $CREATE_FILE 2>&1 
			 fi
			echo ' ' >> $CREATE_FILE 2>&1          
        else
          echo "/etc/ftpd/ftpusers  파일이 없습니다." >> $CREATE_FILE 2>&1
		  echo ' ' >> $CREATE_FILE 2>&1
		fi

      if [ -f /etc/ftpusers ]
        then
          echo "/etc/ftpuser 파일존재" >> $CREATE_FILE 2>&1
          echo "/etc/ftpuser 내용" >> $CREATE_FILE 2>&1
          
			 if [ `cat /etc/ftpusers | grep root | grep -v '#' | wc -l` -eq 1 ]
			 then
					cat /etc/ftpusers | grep root | grep -v '#' >>$CREATE_FILE 2>&1
					echo "☞root 계정 접속 차단됨" >> $CREATE_FILE 2>&1
					cat /etc/ftpusers | grep root >> ftp.ahnlab 2>&1
			else
				echo "☞root 계정 접속 차단되지 않음" >> $CREATE_FILE 2>&1 
			 fi
			echo ' ' >> $CREATE_FILE 2>&1
  
        else
          echo "/etc/ftpusers  파일이 없습니다." >> $CREATE_FILE 2>&1
			echo ' ' >> $CREATE_FILE 2>&1
      fi

      if [ -f /etc/vsftpd/ftpusers ]
        then
          echo "/etc/vsftpd/ftpusers 파일존재" >> $CREATE_FILE 2>&1
          echo "/etc/vsftpd/ftpusers 내용" >> $CREATE_FILE 2>&1
			 
			 if [ `cat /etc/vsftpd/ftpusers | grep root | grep -v '#' | wc -l` -eq 1 ]
			 then
					cat /etc/vsftpd/ftpusers | grep root | grep -v '#' >>$CREATE_FILE 2>&1
					echo "☞root 계정 접속 차단됨" >> $CREATE_FILE 2>&1
					cat /etc/vsftpd/ftpusers | grep root >> ftp.ahnlab 2>&1
			else
				echo "☞root 계정 접속 차단되지 않음" >> $CREATE_FILE 2>&1 
			 fi
			echo ' ' >> $CREATE_FILE 2>&1
        else
          echo "/etc/vsftpd/ftpusers 파일이 없습니다. " >> $CREATE_FILE 2>&1
			echo ' ' >> $CREATE_FILE 2>&1
      fi

		if [ -f /etc/vsftpd.ftpusers ]
        then
          echo "/etc/vsftpd.ftpusers 파일존재" >> $CREATE_FILE 2>&1
          echo "/etc/vsftpd.ftpusers 내용">>$CREATE_FILE 2>&1
			 
          if [ `cat /etc/vsftpd.ftpusers | grep root | grep -v '#' | wc -l` -eq 1 ]
			 then
					cat /etc/vsftpd.ftpusers | grep root | grep -v '#' >>$CREATE_FILE 2>&1
					echo "☞root 계정 접속 차단됨" >> $CREATE_FILE 2>&1
					cat /etc/vsftpd.ftpusers | grep root >> ftp.ahnlab 2>&1
			else
				echo "☞root 계정 접속 차단되지 않음" >> $CREATE_FILE 2>&1 
			 fi
			 echo ' ' >> $CREATE_FILE 2>&1
        else
          echo "/etc/vsftpd.ftpusers 파일이 없습니다. " >> $CREATE_FILE 2>&1
			echo ' ' >> $CREATE_FILE 2>&1
      fi

		if [ -f /etc/vsftpd/user_list ]
        then
          echo "/etc/vsftpd/user_list 파일존재" >> $CREATE_FILE 2>&1
          echo " /etc/vsftpd/user_list 내용" >> $CREATE_FILE 2>&1
			 
          if [ `cat /etc/vsftpd/user_list | grep root | grep -v '#' | wc -l` -eq 1 ]
			 then
					cat /etc/vsftpd/user_list | grep root | grep -v '#' >>$CREATE_FILE 2>&1
					echo "☞root 계정 접속 차단됨" >> $CREATE_FILE 2>&1
					cat /etc/vsftpd/user_list | grep root >> ftp.ahnlab 2>&1
			else
				echo "☞root 계정 접속 차단되지 않음" >> $CREATE_FILE 2>&1 
			 fi
			 echo ' ' >> $CREATE_FILE 2>&1
  
        else
          echo "vsftpd/user_list 파일이 없습니다. " >> $CREATE_FILE 2>&1
			echo ' ' >> $CREATE_FILE 2>&1
      fi

      if [ -f /etc/vsftpd.user_list ]
        then
          echo "/etc/vsftpd.user_list 파일존재" >> $CREATE_FILE 2>&1
          echo " /etc/vsftpd.user_list 내용" >> $CREATE_FILE 2>&1
			 
          if [ `cat /etc/vsftpd/user_list | grep root | grep -v '#' | wc -l` -eq 1 ]
			    then
					  cat /etc/vsftpd/user_list | grep root | grep -v '#' >>$CREATE_FILE 2>&1
					  echo "☞root 계정 접속 차단됨" >> $CREATE_FILE 2>&1
					  cat /etc/vsftpd/user_list | grep root >> ftp.ahnlab 2>&1
			    else
				    echo "☞root 계정 접속 차단되지 않음" >> $CREATE_FILE 2>&1 
			    fi
			  echo ' ' >> $CREATE_FILE 2>&1
  
      else
        echo "vsftpd.user_list 파일이 없습니다. " >> $CREATE_FILE 2>&1
			echo ' ' >> $CREATE_FILE 2>&1
      fi
      
      if [ -f /etc/proftpd.conf ]
        then
          echo "/etc/proftpd.conf 파일존재" >> $CREATE_FILE 2>&1
          echo " /etc/proftpd.conf 내용" >> $CREATE_FILE 2>&1
          if [ `cat /etc/vsftpd/user_list | grep root | grep -v '#' | wc -l` -eq 1 ]
          then
            cat /etc/proftpd.conf | grep -i rootlogin | grep -v '#' >> $CREATE_FILE 2>&1
            echo "☞root 계정 접속 차단됨" >> $CREATE_FILE 2>&1
            cat /etc/proftpd.conf | grep -i rootlogin | grep -v '#' >> ftp.ahnlab 2>&1
          else
            echo "☞root 계정 접속 차단되지 않음" >> $CREATE_FILE 2>&1
          fi
        
        else
          echo "/etc/proftpd.conf 파일이 없습니다. " >> $CREATE_FILE 2>&1
      fi 
  
  else
    echo "☞ ftp Service Disable" >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1

  if [ `cat ftpenable.ahnlab | grep "enable" | wc -l` -gt 0 ]
    then
      if [ `cat ftp.ahnlab | grep root | grep -v grep | wc -l` -eq 0 ]
        then
          echo "★ U_63. 결과 : 취약" >> $CREATE_FILE 2>&1
        else
          echo "★ U_63. 결과 : 양호" >> $CREATE_FILE 2>&1
      fi
    else
      echo "★ U_63. 결과 : 양호" >> $CREATE_FILE 2>&1
  fi

  rm -rf ftpenable.ahnlab ftp.ahnlab

  result="완료"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_64() {
  echo -n "U_64. at 파일 소유자 및 권한 설정 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_64. at 파일 소유자 및 권한 설정 " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "▶ 점검기준 : at 접근제어 파일의 소유자가 root이고, 권한이 640 이하인 경우 양호(권한 640이지만 파일에 내용 없을 시 취약)" >> $CREATE_FILE 2>&1
  echo "              at.deny, at.allow파일 모두 없을 시 관리자 계정 이외는 사용하지 못하므로 양호" >> $CREATE_FILE 2>&1
  echo "▶ 시스템 현황" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  
  
  if [ -f /etc/at.allow ]
    then
      echo "/etc/at.allow 파일이 존재합니다." >> $CREATE_FILE 2>&1
	  	echo `ls -l /etc/at.allow` >> $CREATE_FILE 2>&1
		  echo " " >> $CREATE_FILE 2>&1
		  echo "■/etc/at.allow 파일 내용" >> $CREATE_FILE 2>&1
		  echo "----------------------">>$CREATE_FILE 2>&1
		  if [ `cat /etc/at.allow | wc -l` -ge 1 ];then
			  cat /etc/at.allow >> $CREATE_FILE 2>&1
		  else
			  echo "파일 내용이 없습니다." >> $CREATE_FILE 2>&1
		  fi
		  echo "----------------------">>$CREATE_FILE 2>&1
		
	   if [ \( `ls -l /etc/at.allow | awk '{print $3}' | grep -i root |wc -l` -eq 1 \) -a \( `ls -l /etc/at.allow | grep '...-.-----' | wc -l` -eq 1 \) ]; then
			if [ `cat /etc/at.allow | wc -l` -ge 1 ]; then
				allow_result='true'
			else
				allow_result='false'
			fi
		else
			allow_result='false'
		fi
  else
	  echo "/etc/at.allow 파일이 없습니다." >> $CREATE_FILE 2>&1
		allow_result='true'
  fi
  
  if [ -f /etc/at.deny ]
    then					
      echo "/etc/at.deny 파일이 존재합니다." >> $CREATE_FILE 2>&1
	  	echo `ls -l /etc/at.deny` >> $CREATE_FILE 2>&1
	  	echo " " >> $CREATE_FILE 2>&1
	  	echo "■/etc/at.deny 파일 내용" >> $CREATE_FILE 2>&1
	  	echo "----------------------">>$CREATE_FILE 2>&1
		  if [ `cat /etc/at.deny | wc -l` -ge 1 ];then
			  cat /etc/at.deny >> $CREATE_FILE 2>&1
		  else
			  echo "파일 내용이 없습니다." >> $CREATE_FILE 2>&1
		  fi
		  echo "----------------------">>$CREATE_FILE 2>&1
	  
		  if [ \( `ls -l /etc/at.deny | awk '{print $3}' | grep -i root |wc -l` -eq 1 \) -a \( `ls -l /etc/at.deny | grep '...-.-----' | wc -l` -eq 1 \) ]; then
			  if [ `cat /etc/at.deny | wc -l` -ge 1 ];then
    			deny_result='true'
			  else
				  deny_result='false'
			  fi
			 
		else
			deny_result='false'
		fi
  else
	echo "/etc/at.deny 파일이 없습니다." >> $CREATE_FILE 2>&1
		deny_result='true'
  fi
	  
  echo " " >> $CREATE_FILE 2>&1
    
  if [ $allow_result = 'false' -o $deny_result = 'false' ]
    then
      echo "★ U_64. 결과 : 취약" >> $CREATE_FILE 2>&1
    else
      echo "★ U_64. 결과 : 양호" >> $CREATE_FILE 2>&1
  fi


  result="완료"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_65() {
  echo -n "U_65. SNMP 서비스 구동 점검 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_65. SNMP 서비스 구동 점검 " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "▶ 점검기준 : SNMP 서비스를 사용하지 않는 경우 양호" >> $CREATE_FILE 2>&1
  echo "▶ 시스템 현황" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  echo "[SNMP 서비스 여부]" >> $CREATE_FILE 2>&1
 
  echo " " >> $CREATE_FILE 2>&1

  if [ `ps -ef | grep snmp | grep -v "dmi" | grep -v "grep" | wc -l` -eq 0 ]
    then
      echo "☞ SNMP Service Disable. "  >> $CREATE_FILE 2>&1
    else
      ps -ef | grep snmp | grep -v "dmi" | grep -v "grep" >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1
   
  echo " " >> $CREATE_FILE 2>&1


  echo " " >> $CREATE_FILE 2>&1

  if [ `ps -ef | grep snmp | grep -v "dmi" | grep -v "grep" | wc -l` -eq 0 ]
    then
      echo "★ U_65. 결과 : 양호" >> $CREATE_FILE 2>&1
    else
      echo "★ U_65. 결과 : 취약" >> $CREATE_FILE 2>&1
  fi


  result="완료"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_66() {
  echo -n "U_66. SNMP 서비스 Community String의 복잡성 설정 >>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_66. SNMP 서비스 Community string의 복잡성 설정 " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "▶ 점검기준 : SNMP Community 이름이 public, private 가 아닌 경우 양호" >> $CREATE_FILE 2>&1
  echo "▶ 시스템 현황" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  echo "① SNMP 서비스 여부 " >> $CREATE_FILE 2>&1
  echo "------------------------------------------------------------------------------" >> $CREATE_FILE 2>&1
  if [ `ps -ef | grep snmp | grep -v "dmi" | grep -v "grep" | wc -l` -ge 1 ]
    then
    	echo " " >> $CREATE_FILE 2>&1
    	ps -ef | grep snmp | grep -v "dmi" | grep -v "grep" >> $CREATE_FILE 2>&1
    	echo " " >> $CREATE_FILE 2>&1
    	echo "SNMP가 실행중입니다. "  >> $CREATE_FILE 2>&1
  
  echo " " >> $CREATE_FILE 2>&1

  echo "② 설정파일 CommunityString 현황 " >> $CREATE_FILE 2>&1
  echo "------------------------------------------------------------------------------" >> $CREATE_FILE 2>&1
    
  SPCONF_DIR="/etc/snmpd.conf /etc/snmpdv3.conf /etc/snmp/snmpd.conf /etc/snmp/conf/snmpd.conf /etc/sma/snmp/snmpd.conf"

 for file in $SPCONF_DIR
 do
  if [ -f $file ]
  then
     echo "■ "$file"파일 내 CommunityString 설정" >> $CREATE_FILE 2>&1
     echo "------------------------------------------------------------------------------" >> $CREATE_FILE 2>&1
     echo " " >> $CREATE_FILE 2>&1
     cat $file | grep -i -A1 -B1 "Community" | grep -v "#" >> $CREATE_FILE 2>&1
     echo " " >> $CREATE_FILE 2>&1
  fi
 done 
  
  echo "★ U_66. 결과 : 수동점검" >> $CREATE_FILE 2>&1  
  
else
  echo "SNMP가 비실행중입니다. "  >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "★ U_66. 결과 : 양호" >> $CREATE_FILE 2>&1
fi

	
  result="완료"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}

U_67() {
  echo -n "U_67. 로그온 시 경고 메시지 제공 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_67. 로그온 시 경고 메시지 제공 " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "▶ 점검기준 : 서버 및 Telnet 서비스에 로그온 메시지가 설정되어 있는 경우 양호" >> $CREATE_FILE 2>&1
  echo "▶ 시스템 현황" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  echo "  " >> $CREATE_FILE 2>&1
  
  echo "  " > banner.ahnlab
  echo " " > banner_temp.ahnlab
  
  echo "① 서버 로그온 시 출력 배너(/etc/motd) 확인" >> $CREATE_FILE 2>&1
  echo "------------------------------------------------------------------------------" >> $CREATE_FILE 2>&1
  if [ -f /etc/motd ]
	then  
		if [ `cat /etc/motd | wc -l` -gt 0 ]
    	then
			 echo "양호" >> banner.ahnlab
	   	 cat /etc/motd >> $CREATE_FILE 2>&1
		else
			echo
			echo "취약" >> banner.ahnlab 
		fi
  else
	  echo "/etc/motd 파일이 존재하지 않습니다." >> $CREATE_FILE 2>&1
	  echo "취약" >> banner.ahnlab
  fi
  
  echo "  " >> $CREATE_FILE 2>&1

  echo "② SSH 관련 설정 " >> $CREATE_FILE 2>&1
  echo "------------------------------------------------------------------------------" >> $CREATE_FILE 2>&1
  if [ `ps -ef | grep sshd | grep -v "grep" | wc -l` -eq 0 ]
	  then
		  echo "☞ SSH Service Disable" >> $CREATE_FILE 2>&1
	  else
		  echo "☞ SSH Service Enable" >> $CREATE_FILE 2>&1
		  echo "  " >> $CREATE_FILE 2>&1
          echo "■ ssh 배너 연동 여부" >> $CREATE_FILE 2>&1		  
		  cat ssh-banner.ahnlab >> $CREATE_FILE 2>&1
		  # ssh-banner.ahnlab는 U_01에서 생성 for문 두번돌리지 않기위해..
		  
		  echo "  " >> $CREATE_FILE 2>&1
		  echo "■ 연동된 ssh 배너파일 존재시 해당 파일 내용" >> $CREATE_FILE 2>&1
		  
		  if [ `cat ssh-banner.ahnlab | grep -v "#" | wc -l` -gt 0 ]
		  then
		     cat ssh-banner.ahnlab | grep -v "#" | awk -F " " '{print $4}' >> $CREATE_FILE 2>&1
			 echo "양호" >> banner.ahnlab
		  else
		     echo "ssh 배너 연동이 적절하지 않습니다." >> $CREATE_FILE 2>&1
			 echo "취약" >> banner.ahnlab
		  fi
  fi
  echo "  " >> $CREATE_FILE 2>&1
  echo "  " >> $CREATE_FILE 2>&1

  ps -ef | grep telnetd  | grep -v grep >> banner_temp.ahnlab
  
  if [ -f /etc/inetd.conf ]
  then
  cat /etc/inetd.conf | grep 'telnetd' | grep -v '#' >> banner_temp.ahnlab
  fi
  
  echo "③ telnet 관련 설정 " >> $CREATE_FILE 2>&1
  echo "------------------------------------------------------------------------------" >> $CREATE_FILE 2>&1
  if [ `cat banner_temp.ahnlab | grep telnetd | grep -v grep | wc -l` -gt 0 ]
    then
      echo "☞ Telnet Service Enable" >> $CREATE_FILE 2>&1
	  echo "  " >> $CREATE_FILE 2>&1
      echo "■ TELNET 배너" >> $CREATE_FILE 2>&1
      if [ -f /etc/inetd.conf ]
        then
          if [ `cat /etc/inetd.conf | grep "telnetd" | grep -v "#" | grep "\-b" | grep "\/etc/issue" | wc -l` -eq 0 ]
            then
              echo "취약" >> banner.ahnlab
              echo "/etc/inetd.conf 파일 설정 없음" >> $CREATE_FILE 2>&1
            else
              echo "양호" >> banner.ahnlab
              echo "/etc/inetd.conf 파일 내용" >> $CREATE_FILE 2>&1
              cat /etc/inetd.conf | grep "telnetd" >> $CREATE_FILE 2>&1
          fi
        else
          echo "수동점검" >> banner.ahnlab
          echo "/etc/inetd.conf 파일 존재하지 않음" >> $CREATE_FILE 2>&1
      fi
    else
      echo "양호" >> banner.ahnlab
      echo "☞ Telnet Service Disable" >> $CREATE_FILE 2>&1
  fi

  echo "  " >> $CREATE_FILE 2>&1
  echo "  " >> $CREATE_FILE 2>&1
  
  echo " " > banner_temp.ahnlab

  ps -ef | grep ftpd | grep -v grep >> banner_temp.ahnlab
  
  if [ -f /etc/inetd.conf ]
  then
  cat /etc/inetd.conf | grep 'ftpd' | grep -v '#' >> banner_temp.ahnlab
  fi

  echo "  " >> $CREATE_FILE 2>&1

  if [ `cat banner.ahnlab | grep "취약" | wc -l` -eq 0 ]
    then
      echo "★ U_67. 결과 : 양호" >> $CREATE_FILE 2>&1
    else
      echo "★ U_67. 결과 : 취약" >> $CREATE_FILE 2>&1
  fi

  rm -rf banner.ahnlab
  rm -rf banner_temp.ahnlab
  rm -rf ssh-banner.ahnlab

  result="완료"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_68() {
  echo -n "U_68. NFS 설정파일 접근권한 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_68. NFS 설정파일 접근권한 " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "▶ 점검기준 : NFS 접근제어 설정파일의 소유자가 root이고, 권한이 644 이하인 경우 양호" >> $CREATE_FILE 2>&1
  echo "▶ 시스템 현황" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  if [ `ps -ef | grep "nfsd" | egrep -v "statdaemon|automountd|emi" | grep -v "grep" | wc -l` -gt 0 ] 
    then
      ps -ef | grep "nfsd" | egrep -v "statdaemon|automountd|emi" | grep -v "grep" >> $CREATE_FILE 2>&1
      echo " " >> $CREATE_FILE 2>&1
	  echo "☞ NFS Service Enable" >> $CREATE_FILE 2>&1
    	
	
	if [ -f /etc/exports ]
	then
      if [ `ls -alL /etc/exports | awk '{print $1}' | grep '.....--.--' | wc -l` -eq 1 ]
        then
		  echo "/etc/exports 파일 권한"	>> $CREATE_FILE 2>&1
		  echo " " >> $CREATE_FILE 2>&1
		  ls -alL /etc/exports  >> $CREATE_FILE 2>&1
		  echo " " >> $CREATE_FILE 2>&1
          echo "★ U_68. 결과 : 양호" >> $CREATE_FILE 2>&1
        else
          echo "★ U_68. 결과 : 취약" >> $CREATE_FILE 2>&1
      fi
    else
	  echo " /etc/exports 파일이 없습니다"  >> $CREATE_FILE 2>&1
	  echo " " >> $CREATE_FILE 2>&1
      echo "★ U_68. 결과 : 취약" >> $CREATE_FILE 2>&1
	fi
  
  else
      echo "☞ NFS Service Disable" >> $CREATE_FILE 2>&1
	   echo " " >> $CREATE_FILE 2>&1
	  echo "★ U_68. 결과 : 양호" >> $CREATE_FILE 2>&1
  fi


  result="완료"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_69() {
  echo -n "U_69. expn, vrfy 명령어 제한 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_69. expn, vrfy 명령어 제한 " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "▶ 점검기준 : SMTP 서비스 미사용 또는, noexpn, novrfy 옵션이 설정되어 있는 경우 양호" >> $CREATE_FILE 2>&1
  echo "▶ 시스템 현황" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  echo "① Sendmail 프로세스 확인" >> $CREATE_FILE 2>&1
  
  if [ `ps -ef | grep sendmail | grep -v "grep" | wc -l` -eq 0 ]
    then
      echo "Sendmail Service Disable" >> $CREATE_FILE 2>&1
    else
      ps -ef | grep sendmail | grep -v "grep" >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1


  echo " " >> $CREATE_FILE 2>&1

  echo "② /etc/mail/sendmail.cf 파일의 옵션 확인" >> $CREATE_FILE 2>&1

  if [ -f /etc/mail/sendmail.cf ]
    then
      grep -v '^ *#' /etc/mail/sendmail.cf | grep PrivacyOptions >> $CREATE_FILE 2>&1
    else
      echo "/etc/mail/sendmail.cf 파일 없음" >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1

  if [ `ps -ef | grep sendmail | grep -v "grep" | wc -l` -eq 0 ]
    then
      echo "★ U_69. 결과 : 양호" >> $CREATE_FILE 2>&1
    else
      if [ -f /etc/mail/sendmail.cf ]
        then
          if [ `cat /etc/mail/sendmail.cf | grep -i "O PrivacyOptions" | grep -i "noexpn" | grep -i "novrfy" |grep -v "#" |wc -l ` -eq 1 ]
            then
              echo "★ U_69. 결과 : 양호" >> $CREATE_FILE 2>&1
            else
              echo "★ U_69. 결과 : 취약" >> $CREATE_FILE 2>&1
          fi
        else
          echo "★ U_69. 결과 : 양호" >> $CREATE_FILE 2>&1
      fi
  fi


  result="완료"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}

U_70() {
  echo -n "U_70. Apache 웹서비스  정보 숨김>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_70. Apache 웹서비스 정보 숨김 " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "▶ 점검기준 : ServerTokens 지시자에 Prod 옵션이 설정되어 있는 경우 양호" >> $CREATE_FILE 2>&1
  echo "▶ 시스템 현황" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  confdir="/etc/apache2/apache2.conf /etc/apache2/conf.d/security /etc/apache2/conf-available/security.conf /etc/apache2/conf-enabled/security.conf"

  if [ $web = 'httpd' ]; then
 	if [ -f $conf ]; then
		if [ `cat $conf | grep -i 'servertoken' | grep -i -o "prod" | grep -v '#' | wc -l` -gt 0 ]; then
			echo $conf"의 내용" >> $CREATE_FILE 2>&1
			echo " " >> $CREATE_FILE 2>&1
			cat $conf | grep -i "servertokens" >> $CREATE_FILE 2>&1
			echo " " >> $CREATE_FILE 2>&1
			echo '☞ ServerToken값 prod로 설정되어 있음' >> $CREATE_FILE 2>&1
			echo " " >> $CREATE_FILE 2>&1
			echo "★ U_70. 결과 : 양호" >> $CREATE_FILE 2>&1 
		else
			cat $conf | grep -i "servertokens" >> $CREATE_FILE 2>&1
			echo $conf"의 내용" >> $CREATE_FILE 2>&1
			echo " " >> $CREATE_FILE 2>&1
			echo '☞ ServerToken값 prod로 설정되어 있지 않음' >> $CREATE_FILE 2>&1
			echo " " >> $CREATE_FILE 2>&1
			echo "★ U_70. 결과 : 취약" >> $CREATE_FILE 2>&1
		fi
	 
	fi
	
	
   elif [ $web = 'apache2' ]; then
	
	for file in $confdir
	do
		if [ -f $file ]; then
			if [ `cat $file | grep -i 'servertoken' | grep -i -o "prod" | grep -v '#' | wc -l` -gt 0 ]; then
				echo $file"의 설정 내용" >> $CREATE_FILE 2>&1
				echo ' ' >> $CREATE_FILE 2>&1
				cat $file | grep -i "servertokens">> $CREATE_FILE 2>&1
				cat $file | grep -i "servertokens" >> header 2>&1
				echo ' ' >> $CREATE_FILE 2>&1
		  fi
		fi
	done
  else
		echo '☞ 웹 서비스가 구동중이지 않음' >> $CREATE_FILE 2>&1
 		echo ' ' >> $CREATE_FILE 2>&1
		echo "★ U_52. 결과 :  양호" >> $CREATE_FILE 2>&1
 fi
	
	if [ -f header ]; then
 	  if [ `cat header | grep -i 'servertoken' | grep -i -o 'prod' | grep -v '#' | wc -l` -gt 0 ]
  	  then
  	    echo "★ U_70. 결과 : 양호" >> $CREATE_FILE 2>&1
  	  else
 	     echo "★ U_70. 결과 : 취약" >> $CREATE_FILE 2>&1
 	 fi
	fi
  
	rm -rf header
  
  result="완료"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}

U_71() {
  echo -n "U_71. 최신 보안패치 및 벤더 권고사항 적용 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_71. 최신 보안패치 및 벤더 권고사항 적용 " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "▶ 점검기준 : 패치 적용 정책을 수립하여 주기적으로 패치를 관리하고 있는 경우 양호(담당자 인터뷰를 통해 확인)" >> $CREATE_FILE 2>&1
  echo "▶ 시스템 현황" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  confdir="/bin/rpm /usr/bin/rpm /usr/bin/apt-get"
	
	for file in $confdir
	do
		if [ -f $file ]; then
			if [ `ls -l $file | grep -o rpm | wc -l` -gt 0 ]; then
				rpm -qa | sort >> $CREATE_FILE 2>&1
  			else
				dpkg -l >> $CREATE_FILE 2>&1
			fi
		fi
	done
  
  echo " " >> $CREATE_FILE 2>&1
  echo "★ U_71. 결과 : 수동점검" >> $CREATE_FILE 2>&1


  result="완료"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}

U_72() {
  echo -n "U_72. 로그의 정기적 검토 및 보고 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_72. 로그의 정기적 검토 및 보고 " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "▶ 점검기준 : 로그 기록의 검토, 분석, 리포트 작성 및 보고 등이 정기적으로 이루어지는 경우 양호" >> $CREATE_FILE 2>&1
  echo "▶ 시스템 현황" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  
  echo "☞ 관리파트 진단결과 반영" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "★ U_72. 결과 : 수동점검" >> $CREATE_FILE 2>&1


  result="완료"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_73() {
  echo -n "U_73. 정책에 따른 시스템 로깅 설정 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_73. 정책에 따른 시스템 로깅 설정 " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "▶ 점검기준 : 정책에 따른 시스템 로깅 설정" >> $CREATE_FILE 2>&1
  echo "▶ 시스템 현황" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  echo "☞ syslog 프로세스" >> $CREATE_FILE 2>&1
  
  ps -ef | grep 'syslog' | grep -v 'grep' >> $CREATE_FILE 2>&1

  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  
  echo "☞ 시스템 로깅 설정" >> $CREATE_FILE 2>&1
 
  echo " " >> $CREATE_FILE 2>&1
  
  echo " " > syslog.ahnlab
  
  LoggingDIR="/etc/syslog.conf /etc/rsyslog.conf /etc/syslog-ng.conf"

  for file in $LoggingDIR
	do
	if [ -f $file ]
	 then
	    echo "■ "$file"파일 설정" >> $CREATE_FILE 2>&1
		echo "-------------------------------------------------------" >> $CREATE_FILE 2>&1
		cat $file | grep -v "#" | grep -ve '^ *$'  >> $CREATE_FILE 2>&1
		echo " " >> $CREATE_FILE 2>&1
		
		if [ `cat $file | egrep "info|alert|notice|debug" | egrep "var|log" | wc -l` -gt 0 ]
		 then
		    echo "양호" >> syslog.ahnlab
		else	
			echo "취약" >> syslog.ahnlab
		fi
		if [ `cat $file | egrep "alert|err|crit" | egrep "console|sysmsg" | wc -l` -gt 0 ]
		 then
		    echo "양호" >> syslog.ahnlab
		else	
			echo "취약" >> syslog.ahnlab
		fi
		if [ `cat $file | grep "emerg" | grep "\*" | wc -l` -gt 0 ]
		 then
		    echo "양호" >> syslog.ahnlab
		else	
			echo "취약" >> syslog.ahnlab
		fi
	else
	  echo "■ "$file"파일이 발견되지 않았습니다." >> $CREATE_FILE 2>&1
	  echo "수동점검" >> syslog.ahnlab
	  echo " " >> $CREATE_FILE 2>&1
	fi
	done 
  
  
  echo " " >> $CREATE_FILE 2>&1

  if [ `cat syslog.ahnlab | grep "취약" | wc -l` -eq 0 ]
    then
      if [ `cat syslog.ahnlab | grep "수동점검" | wc -l` -eq 3 ]
	   then
	     echo "★ U_73. 결과 : 수동점검" >> $CREATE_FILE 2>&1
	   else
	     echo "★ U_73. 결과 : 양호" >> $CREATE_FILE 2>&1
	  fi
    else
      echo "★ U_73. 결과 : 취약" >> $CREATE_FILE 2>&1
  fi


  rm -rf syslog.ahnlab
  
  result="완료"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}

#U1. 계정관리
U_01
U_02
U_03
U_04
U_05
U_06
U_07
U_08
U_09
U_10
U_11
U_12
U_13
U_14
U_15
#U2. 파일 및 디렉터리 관리
U_16
U_17
U_18
U_19
U_20
U_21
U_22
U_23
U_24
U_25
U_26
U_27
U_28
U_29
U_30
U_31
U_32
U_33
U_34
#U3. 서비스 관리
U_35
U_36
U_37
U_38
U_39
U_40
U_41
U_42
U_43
U_44
U_45
U_46
U_47
U_48
U_49
U_50
U_51
U_52
U_53
U_54
U_55
U_56
U_57
U_58
U_59
U_60
U_61
U_62
U_63
U_64
U_65
U_66
U_67
U_68
U_69
U_70
#U4. 패치 관리
U_71
#U5. 로그 관리
U_72
U_73




echo "☞ 진단작업이 완료되었습니다. 수고하셨습니다!"

# "***************************************  전체 결과물 파일 생성 시작  ***********************************"

_HOSTNAME=`hostname`
CREATE_FILE_RESULT="Linux__"${_HOSTNAME}"__result".txt
#CREATE_FILE_RESULT=`hostname`"_"`date +%m%d`.txt
echo > $CREATE_FILE_RESULT

echo " "

# "***************************************  전체 결과물 파일 생성 끝 **************************************"

# "**************************************** 진단 결과만 출력 시작 *****************************************"

#echo "▶ 진단결과 ◀" > `hostname`_result.txt 2>&1
#echo " " >> `hostname`_result.txt 2>&1

#cat $CREATE_FILE | egrep '양호|취약|수동점검|해당없음' | grep '★ ' >> `hostname`_result.txt 2>&1

#echo " " >> `hostname`_result.txt 2>&1

# "**************************************** 진단 결과만 출력 끝 *******************************************"
cat $CREATE_FILE >> $CREATE_FILE_RESULT 2>&1

unset FILES
unset HOMEDIRS
unset SERVICE_INETD
unset SERVICE
unset APROC1
unset APROC
unset ACONF
unset AHOME
unset ACFILE
unset ServiceDIR
unset vsfile
unset profile
unset result

rm -Rf list.txt
rm -Rf result.txt
rm -Rf telnetps.ahnlab ftpps.ahnlab



rm -Rf $CREATE_FILE 2>&1

#20160105-01 : U-03 pam_tally2.so 점검 내용 추가 ,  임계값 5 이하 양호 판단 수정 
#20160105-02 : U-22 rsyslog 점검 내용 추가  
#20160106-01 : U-26 점검방법 수정 
#20160106-02 : 점검 방법 수정
#20160106-03 : 점검 방법 수정 
#20160106-01 : 점검 방법 전체 수정 
