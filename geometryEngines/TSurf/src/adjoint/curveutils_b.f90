!        Generated by TAPENADE     (INRIA, Tropics team)
!  Tapenade 3.10 (r5363) -  9 Sep 2014 09:53
!
MODULE CURVEUTILS_B
  USE PRECISION
  USE CONSTANTS
  IMPLICIT NONE

CONTAINS
!  Differentiation of barprojection in reverse (adjoint) mode:
!   gradient     of useful results: xf
!   with respect to varying inputs: x xf x1 x2
!   RW status of diff variables: x:out xf:in-zero x1:out x2:out
  SUBROUTINE BARPROJECTION_B(x1, x1b, x2, x2b, x, xb, xf, xfb, u)
! This subroutine projects the point x onto the bar element defined by points
! x1 and x2, to obtain the projected point xf.
!
! Ney Secco 2016-11
! This will bring dot
    USE UTILITIES_B
    IMPLICIT NONE
! DECLARATIONS
! Input variables
    REAL(kind=realtype), DIMENSION(3), INTENT(IN) :: x1, x2, x
    REAL(kind=realtype), DIMENSION(3) :: x1b, x2b, xb
! Output variables
    REAL(kind=realtype), DIMENSION(3) :: xf
    REAL(kind=realtype), DIMENSION(3) :: xfb
    REAL(kind=realtype) :: u
! Working variables
    REAL(kind=realtype), DIMENSION(3) :: x21, p1, vec
    REAL(kind=realtype), DIMENSION(3) :: x21b, p1b
    REAL(kind=realtype) :: mag2, dotresult
    REAL(kind=realtype) :: mag2b, dotresultb
    INTEGER :: branch
    REAL(kind=realtype) :: ub
! EXECUTION
! Get the relative vectors for the bar element and the point
    x21 = x2 - x1
    CALL DOT(x21, x21, mag2)
    p1 = x - x1
! Compute the amount of the point that projects onto the element
    CALL DOT(x21, p1, dotresult)
    u = dotresult/mag2
! Set the projected point to either the start or end node if
! the projection lies outside the node
    IF (u .LT. 0) THEN
      u = 0
      CALL PUSHCONTROL2B(0)
    ELSE IF (u .GT. 1) THEN
      u = 1
      CALL PUSHCONTROL2B(1)
    ELSE
      CALL PUSHCONTROL2B(2)
    END IF
    x1b = 0.0
    x21b = 0.0
    x1b = xfb
    ub = SUM(x21*xfb)
    x21b = u*xfb
    CALL POPCONTROL2B(branch)
    IF (branch .EQ. 0) THEN
      ub = 0.0
    ELSE IF (branch .EQ. 1) THEN
      ub = 0.0
    END IF
    dotresultb = ub/mag2
    mag2b = -(dotresult*ub/mag2**2)
    p1b = 0.0
    CALL DOT_B0(x21, x21b, p1, p1b, dotresult, dotresultb)
    xb = 0.0
    xb = p1b
    CALL DOT_B0(x21, x21b, x21, x21b, mag2, mag2b)
    x1b = x1b - x21b - p1b
    x2b = 0.0
    x2b = x21b
    xfb = 0.0
  END SUBROUTINE BARPROJECTION_B
  SUBROUTINE BARPROJECTION(x1, x2, x, xf, u)
! This subroutine projects the point x onto the bar element defined by points
! x1 and x2, to obtain the projected point xf.
!
! Ney Secco 2016-11
! This will bring dot
    USE UTILITIES_B
    IMPLICIT NONE
! DECLARATIONS
! Input variables
    REAL(kind=realtype), DIMENSION(3), INTENT(IN) :: x1, x2, x
! Output variables
    REAL(kind=realtype), DIMENSION(3), INTENT(OUT) :: xf
    REAL(kind=realtype), INTENT(OUT) :: u
! Working variables
    REAL(kind=realtype), DIMENSION(3) :: x21, p1, vec
    REAL(kind=realtype) :: mag2, dotresult
! EXECUTION
! Get the relative vectors for the bar element and the point
    x21 = x2 - x1
    CALL DOT(x21, x21, mag2)
    p1 = x - x1
! Compute the amount of the point that projects onto the element
    CALL DOT(x21, p1, dotresult)
    u = dotresult/mag2
! Set the projected point to either the start or end node if
! the projection lies outside the node
    IF (u .LT. 0) THEN
      u = 0
    ELSE IF (u .GT. 1) THEN
      u = 1
    END IF
! Compute the new projected point coordinates in the global frame
    xf = x1 + u*x21
  END SUBROUTINE BARPROJECTION
!  Differentiation of computetangent in reverse (adjoint) mode:
!   gradient     of useful results: tangent x1 x2
!   with respect to varying inputs: tangent x1 x2
!   RW status of diff variables: tangent:in-zero x1:incr x2:incr
  SUBROUTINE COMPUTETANGENT_B(x1, x1b, x2, x2b, tangent, tangentb)
! This subroutine computes a normalized vector pointing from x1 to x2
!
! Ney Secco 2016-11
    USE UTILITIES_B
    IMPLICIT NONE
! DECLARATIONS
! Input variables
    REAL(kind=realtype), DIMENSION(3), INTENT(IN) :: x1, x2
    REAL(kind=realtype), DIMENSION(3) :: x1b, x2b
! Output variables
    REAL(kind=realtype), DIMENSION(3) :: tangent
    REAL(kind=realtype), DIMENSION(3) :: tangentb
! Working variables
    REAL(kind=realtype), DIMENSION(3) :: x21
    REAL(kind=realtype), DIMENSION(3) :: x21b
    REAL(kind=realtype) :: dotresult
    REAL(kind=realtype) :: dotresultb
    INTRINSIC SQRT
    REAL(kind=realtype) :: temp
! EXECUTION
! Get the relative vectors for the bar element
    x21 = x2 - x1
! Normalize vector (dot defined in Utilities.F90)
    CALL DOT(x21, x21, dotresult)
    x21b = 0.0
    temp = SQRT(dotresult)
    x21b = tangentb/temp
    IF (dotresult .EQ. 0.0) THEN
      dotresultb = 0.0
    ELSE
      dotresultb = SUM(-(x21*tangentb/temp))/(temp**2*2.0)
    END IF
    CALL DOT_B0(x21, x21b, x21, x21b, dotresult, dotresultb)
    x2b = x2b + x21b
    x1b = x1b - x21b
    tangentb = 0.0
  END SUBROUTINE COMPUTETANGENT_B
  SUBROUTINE COMPUTETANGENT(x1, x2, tangent)
! This subroutine computes a normalized vector pointing from x1 to x2
!
! Ney Secco 2016-11
    USE UTILITIES_B
    IMPLICIT NONE
! DECLARATIONS
! Input variables
    REAL(kind=realtype), DIMENSION(3), INTENT(IN) :: x1, x2
! Output variables
    REAL(kind=realtype), DIMENSION(3), INTENT(OUT) :: tangent
! Working variables
    REAL(kind=realtype), DIMENSION(3) :: x21
    REAL(kind=realtype) :: dotresult
    INTRINSIC SQRT
! EXECUTION
! Get the relative vectors for the bar element
    x21 = x2 - x1
! Normalize vector (dot defined in Utilities.F90)
    CALL DOT(x21, x21, dotresult)
    tangent = x21/SQRT(dotresult)
  END SUBROUTINE COMPUTETANGENT
END MODULE CURVEUTILS_B
