---
title: "Linux Semaphore 확인 및 삭제"
excerpt: "Linux Semaphore 확인 및 삭제"
categories: 
  - Linux
last_modified_at: 2021-02-18T09:29:00+09:00
tags: 
    - Linux
    - CentOS
    - Redhat
    - Semaphore
    - Apache
author_profile: true
read_time: true
toc_label: "Semaphore 확인 및 삭제" 
toc_icon: "cog" 
toc: true
toc_sticky: true
---


## Semaphore?  
프로세스 간 메시지를 전송하거나, 공유메모리를 통해 특정 데이터를 공유하게 되는 경우 문제가 발생할 수 있다.
즉, 공유된 자원에 여러 개의 프로세스가 동시에 접근하면서 문제가 발생하는 것이다. 
공유된 자원 속 하나의 데이터는 한 번에 하나의 프로세스만 접근할 수 있도록 제한해 두어야 하는데, 
이를 위하여 고안된 것이 바로 Semaphore 세마포어 이다.
---

<br>

## Delete Semaphore
아파치 동작 환경에서 각 프로세스간 데이터 공유 및 동기화를 위해서 Semaphore 라는것을 생성한다.
문제는 아파치가 정상적인 종료가 아닌 강제 종료를 하게 된 경우 생성된 Semaphore 가 삭제 되지 못하고 누적이 된다는 것이다
때문에 서버에 한계선 이상까지 생성된 Semaphore 에 의해 새로운 아파치 시작시 Semaphore 를 생성하지 못해서 아파치가 시작이 되지 않는 증상이 나올 수 있다.
<br>
* 아래 내용을 vi 편집기로 열어 붙여넣은 후, 실행

```
#/bin/bash
  
SEM_LIST1=`ipcs -m | grep root | awk '{print $2}'`
SEM_LIST2=`ipcs -s | grep root | awk '{print $2}'`

#공유 메모리 자원 삭제
for i in $SEM_LIST1
do
  ipcrm -m $list
done

#세마포어 삭제
for j in $SEM_LIST2
do
  ipcrm -s $list
done
```
<br>
* 명령어 참고
```
ipcs -a   // 모든 IPC 자원을 조회
ipcs -q   // 메시지 큐 자원을 조회
ipcs -m   // 공유메모리 자원을 조회
ipcs -s    // 세마포어 자원을 조회 
ipcrm -q  [ID]  // 해당 메시지 큐 자원을 삭제
ipcrm -m [ID]  // 해당 공유메모리 자원을 삭제
ipcrm -s  [ID]  // 해당 세마포어 자원을 삭제
```
