module TimeEvolution

implicit none
private

public time_evolution
public time_evolution_bridge

contains

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

subroutine time_evolution(y,initY,g,N,nTimeSteps,Ms, &
 bL1,bL2,bL3,bL4,bLF,a1,a2,a3,a4,a5,bR1,bR2,bR3,bR4,bRF,deltaT)


  real*8, intent(in)  :: initY(:), g(:), Ms, deltaT

  real*8, intent(in)  :: bL1,bL2,bL3,bL4,bLF
  real*8, intent(in)  :: a1,a2,a3,a4,a5
  real*8, intent(in)  :: bR1,bR2,bR3,bR4,bRF
  integer, intent(in) :: N, nTimeSteps

  real*8, intent(out) :: y(N+1,nTimeSteps+1)

  real*8              :: F
  integer             :: i, t


  
  !!! First step 1: !!!
  t = 1
  F = 0

    y(1,1) = bL1*initY(1)+bL2*initY(2)+bL3*initY(3)+bL4*initY(1)+bLF*0
    y(2,1) = a1*(initY(4)-initY(2)+2*initY(1)) + a2*(initY(3)+initY(1)) &
 + a3*initY(2) + a4*initY(2) + a5*(initY(3)+initY(1))
    y(N-1,1) = a1*(2*initY(N)-initY(N-1)+initY(N-3)) &
 + a2*(initY(N)+initY(N-2)) + a3*initY(N-1) + a4*initY(N-1) &
 + a5*(initY(N)+initY(N-2))
    y(N,1) = bR1*initY(N) + bR2*initY(N-1) + bR3*initY(N-1) + bR4*initY(N) &
 + bRF*0

    do i=3,(N-1)
      y(i,t) = a1*(initY(i+2)+initY(i-2)) + a2*(initY(i+1) + initY(i-1)) &
 + a3*initY(i) + a4*initY(i) + a5*(initY(i+1)+initY(i-1)) &
 + deltaT*deltaT*N*F*g(i)/Ms
    end do

 ! Now the second step:
 t = 2
   
    y(1,t) = bL1*y(1,t-1)+bL2*y(2,t-1)+bL3*y(3,t-1)+bL4*initY(1)+bLF*0
    y(2,t) = a1*(y(4,t-1)-y(2,t-1)+2*y(1,t-1)) + a2*(y(3,t-1)+y(1,t-1)) &
 + a3*y(2,t-1) + a4*initY(2) + a5*(initY(3)+initY(1))
    y(N-1,t) = a1*(2*y(N,t-1)-y(N-1,t-1)+y(N-3,t-1)) &
 + a2*(y(N,t-1)+y(N-2,t-1)) + a3*y(N-1,t-1) + a4*initY(N-1) &
 + a5*(initY(N)+initY(N-2))
    y(N,t) = bR1*y(N,t-1) + br2*y(N-1,t-1) + bR3*y(N-1,t-1) + bR4*initY(N) &
 + bRF*0

    do i=3,(N-1)
      y(i,t) = a1*(y(i+2,t-1)+y(i-2,t-1)) + a2*(y(i+1,t-1) + y(i-1,t-1)) &
 + a3*y(i,t-1) + a4*initY(i) + a5*(initY(i+1)+initY(i-1)) &
 + deltaT*deltaT*N*F*g(i)/Ms
    end do


! Finally the Great Time Loop:

do t=3,(nTimeSteps+1)
    y(1,t) = bL1*y(1,t-1)+bL2*y(2,t-1)+bL3*y(3,t-1)+bL4*y(1,t-2)+bLF*0
    y(2,t) = a1*(y(4,t-1)-y(2,t-1)+2*y(1,t-1)) + a2*(y(3,t-1)+y(1,t-1)) &
 + a3*y(2,t-1) + a4*y(2,t-2) + a5*(y(3,t-2)+y(1,t-2))
    y(N-1,t) = a1*(2*y(N,t-1)-y(N-1,t-1)+y(N-3,t-1)) &
 + a2*(y(N,t-1)+y(N-2,t-1)) + a3*y(N-1,t-1) + a4*y(N-1,t-2) &
 + a5*(y(N,t-2)+y(N-2,t-2))
    y(N,t) = bR1*y(N,t-1) + br2*y(N-1,t-1) + bR3*y(N-1,t-1) + bR4*y(N,t-2) &
 + bRF*0

    do i=3,(N-1)
      y(i,t) = a1*(y(i+2,t-1)+y(i-2,t-1)) + a2*(y(i+1,t-1) + y(i-1,t-1)) &
 + a3*y(i,t-1) + a4*y(i,t-2) + a5*(y(i+1,t-2)+y(i-1,t-2)) &
 + deltaT*deltaT*N*F*g(i)/Ms
    end do

  if (t==1) then
    F = 1.5d1
  else if (t==100) then
    F = 0d0
  end if

end do

end subroutine


!!!!!!!!!!!!

subroutine time_evolution_bridge(bridgeY,initY,g,N,nTimeSteps,Ms,bridgePosition, &
 bL1,bL2,bL3,bL4,bLF,a1,a2,a3,a4,a5,bR1,bR2,bR3,bR4,bRF,deltaT)


  real*8, intent(in)  :: initY(:), g(:), Ms, deltaT, bridgePosition

  real*8, intent(in)  :: bL1,bL2,bL3,bL4,bLF
  real*8, intent(in)  :: a1,a2,a3,a4,a5
  real*8, intent(in)  :: bR1,bR2,bR3,bR4,bRF
  integer, intent(in) :: N, nTimeSteps

  real*8, intent(out) :: bridgeY(3,nTimeSteps+1)

  real*8              :: F, y(N+1,3)
  integer             :: i, t, localt, bridgeElement

  y = 0
  

  bridgeElement = nint(bridgePosition*N)
  !!! First step 1: !!!
  t = 1
  localt = 3
!!!!!!!!!!!!!!!!! Magic numbers are highly discouraged, hence
!!!!!!!!!!!!!!!!! localt having a constant value of 3 (which
!!!!!!!!!!!!!!!!! helps continuity as well.
  F = 0

    y(1,localt) = bL1*initY(1)+bL2*initY(2)+bL3*initY(3)+bL4*initY(1)+bLF*0
    y(2,localt) = a1*(initY(4)-initY(2)+2*initY(1)) + a2*(initY(3)+initY(1)) &
 + a3*initY(2) + a4*initY(2) + a5*(initY(3)+initY(1))
    y(N-1,localt) = a1*(2*initY(N)-initY(N-1)+initY(N-3)) &
 + a2*(initY(N)+initY(N-2)) + a3*initY(N-1) + a4*initY(N-1) &
 + a5*(initY(N)+initY(N-2))
    y(N,localt) = bR1*initY(N) + bR2*initY(N-1) + bR3*initY(N-1) + bR4*initY(N) &
 + bRF*0

    do i=3,(N-1)
      y(i,localt) = a1*(initY(i+2)+initY(i-2)) + a2*(initY(i+1) + initY(i-1)) &
 + a3*initY(i) + a4*initY(i) + a5*(initY(i+1)+initY(i-1)) &
 + deltaT*deltaT*N*F*g(i)/Ms
    end do

! Transfer the bridge element string amplitudes to bridgeY:
  do i=1,3
    bridgeY(i,t) = y(bridgeElement-2+i,localt)
  end do

  y(:,localt-2) = y(:,localt-1)
  y(:,localt-1) = y(:,localt)

 ! Now the second step:
 t = 2
   
    y(1,localt) = bL1*y(1,localt-1)+bL2*y(2,localt-1)+bL3*y(3,localt-1)+bL4*initY(1)+bLF*0
    y(2,localt) = a1*(y(4,localt-1)-y(2,localt-1)+2*y(1,localt-1)) + a2*(y(3,localt-1)+y(1,localt-1)) &
 + a3*y(2,localt-1) + a4*initY(2) + a5*(initY(3)+initY(1))
    y(N-1,localt) = a1*(2*y(N,localt-1)-y(N-1,localt-1)+y(N-3,localt-1)) &
 + a2*(y(N,localt-1)+y(N-2,localt-1)) + a3*y(N-1,localt-1) + a4*initY(N-1) &
 + a5*(initY(N)+initY(N-2))
    y(N,localt) = bR1*y(N,localt-1) + br2*y(N-1,localt-1) + bR3*y(N-1,localt-1) + bR4*initY(N) &
 + bRF*0

    do i=3,(N-1)
      y(i,localt) = a1*(y(i+2,localt-1)+y(i-2,localt-1)) + a2*(y(i+1,localt-1) + y(i-1,localt-1)) &
 + a3*y(i,localt-1) + a4*initY(i) + a5*(initY(i+1)+initY(i-1)) &
 + deltaT*deltaT*N*F*g(i)/Ms
    end do

! Transfer the bridge element string amplitudes to bridgeY:
  do i=1,3
    bridgeY(i,t) = y(bridgeElement-2+i,localt)
  end do

  y(:,localt-2) = y(:,localt-1)
  y(:,localt-1) = y(:,localt)


! Finally the Great Time Loop:

do t=3,(nTimeSteps+1)
    y(1,localt) = bL1*y(1,localt-1)+bL2*y(2,localt-1)+bL3*y(3,localt-1)+bL4*y(1,localt-2)+bLF*0
    y(2,localt) = a1*(y(4,localt-1)-y(2,localt-1)+2*y(1,localt-1)) + a2*(y(3,localt-1)+y(1,localt-1)) &
 + a3*y(2,localt-1) + a4*y(2,localt-2) + a5*(y(3,localt-2)+y(1,localt-2))
    y(N-1,localt) = a1*(2*y(N,localt-1)-y(N-1,localt-1)+y(N-3,localt-1)) &
 + a2*(y(N,localt-1)+y(N-2,localt-1)) + a3*y(N-1,localt-1) + a4*y(N-1,localt-2) &
 + a5*(y(N,localt-2)+y(N-2,localt-2))
    y(N,localt) = bR1*y(N,localt-1) + br2*y(N-1,localt-1) + bR3*y(N-1,localt-1) + bR4*y(N,localt-2) &
 + bRF*0

    do i=3,(N-1)
      y(i,localt) = a1*(y(i+2,localt-1)+y(i-2,localt-1)) + a2*(y(i+1,localt-1) + y(i-1,localt-1)) &
 + a3*y(i,localt-1) + a4*y(i,localt-2) + a5*(y(i+1,localt-2)+y(i-1,localt-2)) &
 + deltaT*deltaT*N*F*g(i)/Ms
    end do

  if (t==10) then
    F = 1.5d1
  else if (t==100) then
    F = 0d0
  end if

! Transfer the bridge element string amplitudes to bridgeY:
  do i=1,3
    bridgeY(i,t) = y(bridgeElement-2+i,localt)
  end do

  y(:,localt-2) = y(:,localt-1)
  y(:,localt-1) = y(:,localt)

end do

end subroutine


end module