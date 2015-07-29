#!/usr/bin/env python

import os
import time
import sys
import popen2
import subprocess

from threading import Thread


class testit(Thread):
    def __init__(self,command,logfile):
        Thread.__init__(self)
        self.command=command
        self.status=-1
        self.report=''
        self.pid=-1
        self.subproc=None
        self.f=None
        self.logfile=logfile
    def run(self):

        f=open(self.logfile,'w')
    
        p3=subprocess.Popen(self.command,shell=True,stderr=subprocess.STDOUT,stdout=f)
        self.pid=p3.pid
        self.subproc=p3
        self.f=f
        exitcode=os.waitpid(p3.pid,0)

def main(argv) :

    firstA=0
    iter='0'
    if argv[0]=="-n":
        iter=argv[1]
        firstA=2
    fout=open('memory_'+iter+'.out','w')
    logfile='checkMem_'+iter+'.log'
    print logfile    

    rvComm=' '.join(argv[firstA:])

    clist = []

    current = testit(rvComm,logfile)
    current.start()
    
#    print proc.pid()
    childpid=-1

    mems=[]
    vmems=[]
    events=[]
    interval=1
    while(current.isAlive()):
#        print current.pid
        os.system('sleep '+str(interval))

        if current.pid>0:
#            cmd='cat /proc/'+str(current.pid)+'/stat | cut -d" " -f23'
            cmd='grep VmRSS /proc/'+str(current.pid)+'/status'
            cmd2='grep VmSize /proc/'+str(current.pid)+'/status'
            if os.path.exists('/proc/'+str(current.pid)+'/stat'):
                mem=os.popen(cmd).readline()
                mems.append(float(mem.strip().split()[1]))
                vmem=os.popen(cmd2).readline()
                vmems.append(float(vmem.strip().split()[1]))
#                print mems[-1]/(1000.*1024.)
                fout.write(str(mems[-1])+' ')
                fout.write(str(vmems[-1])+' ')
                if os.path.exists(logfile):
#                    print current.f
#                    evs=current.f.readlines()[-100:]
                    eventNum=-1
#                    for l in evs:
                    evs= os.popen('tail -100 '+logfile+' | grep "Begin processing the" | tail -1')
                    evsRes=evs.readline()
                    if 'Begin processing' in evsRes:
                        if len(evsRes.split())>3:
                            eventNum=int(evsRes.split()[3][:-2])
                    events.append(eventNum)
                else:
                    events.append(-1)
                fout.write(str(events[-1])+'\n')    
                if len(mems)%10==0:
                    fout.flush()
#        else:    
#            if ( current.pid>0):
#                cmd='cat /proc/'+str(current.pid)+'/stat'
#                l=os.popen(cmd).readline().strip()
#                childpid=int(l.split()[3])
#                cmd='cat /proc/'+str(childpid)+'/stat'
#                l=os.popen(cmd).readline().strip()
#                childpid=int(l.split()[3])

if __name__ == '__main__' :
    main(sys.argv[1:])
