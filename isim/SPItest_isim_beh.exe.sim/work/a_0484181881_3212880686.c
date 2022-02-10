/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                       */
/*  \   \        Copyright (c) 2003-2009 Xilinx, Inc.                */
/*  /   /          All Right Reserved.                                 */
/* /---/   /\                                                         */
/* \   \  /  \                                                      */
/*  \___\/\___\                                                    */
/***********************************************************************/

/* This file is designed for use with ISim build 0x8ef4fb42 */

#define XSI_HIDE_SYMBOL_SPEC true
#include "xsi.h"
#include <memory.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
static const char *ng0 = "C:/GitRepos/XilinxDDRBurst/SlowInputByEight.vhd";
extern char *IEEE_P_2592010699;

unsigned char ieee_p_2592010699_sub_1744673427_503743352(char *, char *, unsigned int , unsigned int );


static void work_a_0484181881_3212880686_p_0(char *t0)
{
    char *t1;
    unsigned char t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;

LAB0:    xsi_set_current_line(26, ng0);
    t1 = (t0 + 844U);
    t2 = ieee_p_2592010699_sub_1744673427_503743352(IEEE_P_2592010699, t1, 0U, 0U);
    if (t2 != 0)
        goto LAB2;

LAB4:
LAB3:    t1 = (t0 + 2288);
    *((int *)t1) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(27, ng0);
    t3 = (t0 + 1052U);
    t4 = *((char **)t3);
    t3 = (t0 + 2348);
    t5 = (t3 + 32U);
    t6 = *((char **)t5);
    t7 = (t6 + 40U);
    t8 = *((char **)t7);
    memcpy(t8, t4, 32U);
    xsi_driver_first_trans_fast_port(t3);
    goto LAB3;

}

static void work_a_0484181881_3212880686_p_1(char *t0)
{
    char *t1;
    unsigned char t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;

LAB0:    xsi_set_current_line(35, ng0);
    t1 = (t0 + 752U);
    t2 = ieee_p_2592010699_sub_1744673427_503743352(IEEE_P_2592010699, t1, 0U, 0U);
    if (t2 != 0)
        goto LAB2;

LAB4:
LAB3:    t1 = (t0 + 2296);
    *((int *)t1) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(37, ng0);
    t3 = (t0 + 1144U);
    t4 = *((char **)t3);
    t3 = (t0 + 2384);
    t5 = (t3 + 32U);
    t6 = *((char **)t5);
    t7 = (t6 + 40U);
    t8 = *((char **)t7);
    memcpy(t8, t4, 32U);
    xsi_driver_first_trans_fast(t3);
    goto LAB3;

}

static void work_a_0484181881_3212880686_p_2(char *t0)
{
    char *t1;
    char *t2;
    unsigned int t3;
    unsigned int t4;
    unsigned int t5;
    char *t6;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    int t11;
    unsigned char t12;

LAB0:    xsi_set_current_line(45, ng0);
    t1 = (t0 + 1052U);
    t2 = *((char **)t1);
    t3 = (31 - 30);
    t4 = (t3 * 1U);
    t5 = (0 + t4);
    t1 = (t2 + t5);
    t6 = (t0 + 2420);
    t7 = (t6 + 32U);
    t8 = *((char **)t7);
    t9 = (t8 + 40U);
    t10 = *((char **)t9);
    memcpy(t10, t1, 31U);
    xsi_driver_first_trans_delta(t6, 0U, 31U, 0LL);
    xsi_set_current_line(47, ng0);
    t1 = (t0 + 592U);
    t2 = *((char **)t1);
    t11 = (0 - 3);
    t3 = (t11 * -1);
    t4 = (1U * t3);
    t5 = (0 + t4);
    t1 = (t2 + t5);
    t12 = *((unsigned char *)t1);
    t6 = (t0 + 2420);
    t7 = (t6 + 32U);
    t8 = *((char **)t7);
    t9 = (t8 + 40U);
    t10 = *((char **)t9);
    *((unsigned char *)t10) = t12;
    xsi_driver_first_trans_delta(t6, 31U, 1, 0LL);
    xsi_set_current_line(48, ng0);
    t1 = (t0 + 592U);
    t2 = *((char **)t1);
    t11 = (1 - 3);
    t3 = (t11 * -1);
    t4 = (1U * t3);
    t5 = (0 + t4);
    t1 = (t2 + t5);
    t12 = *((unsigned char *)t1);
    t6 = (t0 + 2420);
    t7 = (t6 + 32U);
    t8 = *((char **)t7);
    t9 = (t8 + 40U);
    t10 = *((char **)t9);
    *((unsigned char *)t10) = t12;
    xsi_driver_first_trans_delta(t6, 23U, 1, 0LL);
    xsi_set_current_line(49, ng0);
    t1 = (t0 + 592U);
    t2 = *((char **)t1);
    t11 = (2 - 3);
    t3 = (t11 * -1);
    t4 = (1U * t3);
    t5 = (0 + t4);
    t1 = (t2 + t5);
    t12 = *((unsigned char *)t1);
    t6 = (t0 + 2420);
    t7 = (t6 + 32U);
    t8 = *((char **)t7);
    t9 = (t8 + 40U);
    t10 = *((char **)t9);
    *((unsigned char *)t10) = t12;
    xsi_driver_first_trans_delta(t6, 15U, 1, 0LL);
    xsi_set_current_line(50, ng0);
    t1 = (t0 + 592U);
    t2 = *((char **)t1);
    t11 = (3 - 3);
    t3 = (t11 * -1);
    t4 = (1U * t3);
    t5 = (0 + t4);
    t1 = (t2 + t5);
    t12 = *((unsigned char *)t1);
    t6 = (t0 + 2420);
    t7 = (t6 + 32U);
    t8 = *((char **)t7);
    t9 = (t8 + 40U);
    t10 = *((char **)t9);
    *((unsigned char *)t10) = t12;
    xsi_driver_first_trans_delta(t6, 7U, 1, 0LL);
    t1 = (t0 + 2304);
    *((int *)t1) = 1;

LAB1:    return;
}


extern void work_a_0484181881_3212880686_init()
{
	static char *pe[] = {(void *)work_a_0484181881_3212880686_p_0,(void *)work_a_0484181881_3212880686_p_1,(void *)work_a_0484181881_3212880686_p_2};
	xsi_register_didat("work_a_0484181881_3212880686", "isim/SPItest_isim_beh.exe.sim/work/a_0484181881_3212880686.didat");
	xsi_register_executes(pe);
}
