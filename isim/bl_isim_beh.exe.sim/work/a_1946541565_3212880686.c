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
static const char *ng0 = "C:/GitRepos/XilinxDDRBurst/SPIbus.vhd";
extern char *IEEE_P_2592010699;

unsigned char ieee_p_2592010699_sub_1690584930_503743352(char *, unsigned char );
unsigned char ieee_p_2592010699_sub_1744673427_503743352(char *, char *, unsigned int , unsigned int );


static void work_a_1946541565_3212880686_p_0(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;

LAB0:    xsi_set_current_line(69, ng0);

LAB3:    t1 = (t0 + 2340U);
    t2 = *((char **)t1);
    t1 = (t0 + 4156);
    t3 = (t1 + 32U);
    t4 = *((char **)t3);
    t5 = (t4 + 40U);
    t6 = *((char **)t5);
    memcpy(t6, t2, 16U);
    xsi_driver_first_trans_fast_port(t1);

LAB2:    t7 = (t0 + 4088);
    *((int *)t7) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}

static void work_a_1946541565_3212880686_p_1(char *t0)
{
    char *t1;
    char *t2;
    unsigned char t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;

LAB0:    xsi_set_current_line(70, ng0);

LAB3:    t1 = (t0 + 2708U);
    t2 = *((char **)t1);
    t3 = *((unsigned char *)t2);
    t1 = (t0 + 4192);
    t4 = (t1 + 32U);
    t5 = *((char **)t4);
    t6 = (t5 + 40U);
    t7 = *((char **)t6);
    *((unsigned char *)t7) = t3;
    xsi_driver_first_trans_fast_port(t1);

LAB2:    t8 = (t0 + 4096);
    *((int *)t8) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}

static void work_a_1946541565_3212880686_p_2(char *t0)
{
    char *t1;
    unsigned char t2;
    char *t3;
    char *t4;
    unsigned int t5;
    unsigned int t6;
    unsigned int t7;
    char *t8;
    char *t9;
    char *t10;
    char *t11;
    char *t12;

LAB0:    xsi_set_current_line(74, ng0);
    t1 = (t0 + 568U);
    t2 = ieee_p_2592010699_sub_1744673427_503743352(IEEE_P_2592010699, t1, 0U, 0U);
    if (t2 != 0)
        goto LAB2;

LAB4:
LAB3:    t1 = (t0 + 4104);
    *((int *)t1) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(75, ng0);
    t3 = (t0 + 1328U);
    t4 = *((char **)t3);
    t5 = (7 - 6);
    t6 = (t5 * 1U);
    t7 = (0 + t6);
    t3 = (t4 + t7);
    t8 = (t0 + 4228);
    t9 = (t8 + 32U);
    t10 = *((char **)t9);
    t11 = (t10 + 40U);
    t12 = *((char **)t11);
    memcpy(t12, t3, 7U);
    xsi_driver_first_trans_delta(t8, 0U, 7U, 0LL);
    xsi_set_current_line(76, ng0);
    t1 = (t0 + 1420U);
    t3 = *((char **)t1);
    t5 = (7 - 6);
    t6 = (t5 * 1U);
    t7 = (0 + t6);
    t1 = (t3 + t7);
    t4 = (t0 + 4264);
    t8 = (t4 + 32U);
    t9 = *((char **)t8);
    t10 = (t9 + 40U);
    t11 = *((char **)t10);
    memcpy(t11, t1, 7U);
    xsi_driver_first_trans_delta(t4, 0U, 7U, 0LL);
    xsi_set_current_line(77, ng0);
    t1 = (t0 + 1512U);
    t3 = *((char **)t1);
    t5 = (7 - 6);
    t6 = (t5 * 1U);
    t7 = (0 + t6);
    t1 = (t3 + t7);
    t4 = (t0 + 4300);
    t8 = (t4 + 32U);
    t9 = *((char **)t8);
    t10 = (t9 + 40U);
    t11 = *((char **)t10);
    memcpy(t11, t1, 7U);
    xsi_driver_first_trans_delta(t4, 0U, 7U, 0LL);
    xsi_set_current_line(79, ng0);
    t1 = (t0 + 960U);
    t3 = *((char **)t1);
    t2 = *((unsigned char *)t3);
    t1 = (t0 + 4228);
    t4 = (t1 + 32U);
    t8 = *((char **)t4);
    t9 = (t8 + 40U);
    t10 = *((char **)t9);
    *((unsigned char *)t10) = t2;
    xsi_driver_first_trans_delta(t1, 7U, 1, 0LL);
    xsi_set_current_line(80, ng0);
    t1 = (t0 + 1144U);
    t3 = *((char **)t1);
    t2 = *((unsigned char *)t3);
    t1 = (t0 + 4264);
    t4 = (t1 + 32U);
    t8 = *((char **)t4);
    t9 = (t8 + 40U);
    t10 = *((char **)t9);
    *((unsigned char *)t10) = t2;
    xsi_driver_first_trans_delta(t1, 7U, 1, 0LL);
    xsi_set_current_line(81, ng0);
    t1 = (t0 + 1236U);
    t3 = *((char **)t1);
    t2 = *((unsigned char *)t3);
    t1 = (t0 + 4300);
    t4 = (t1 + 32U);
    t8 = *((char **)t4);
    t9 = (t8 + 40U);
    t10 = *((char **)t9);
    *((unsigned char *)t10) = t2;
    xsi_driver_first_trans_delta(t1, 7U, 1, 0LL);
    xsi_set_current_line(83, ng0);
    t1 = (t0 + 2064U);
    t3 = *((char **)t1);
    t2 = *((unsigned char *)t3);
    t1 = (t0 + 4336);
    t4 = (t1 + 32U);
    t8 = *((char **)t4);
    t9 = (t8 + 40U);
    t10 = *((char **)t9);
    *((unsigned char *)t10) = t2;
    xsi_driver_first_trans_fast(t1);
    xsi_set_current_line(84, ng0);
    t1 = (t0 + 1604U);
    t3 = *((char **)t1);
    t2 = *((unsigned char *)t3);
    t1 = (t0 + 4372);
    t4 = (t1 + 32U);
    t8 = *((char **)t4);
    t9 = (t8 + 40U);
    t10 = *((char **)t9);
    *((unsigned char *)t10) = t2;
    xsi_driver_first_trans_fast(t1);
    xsi_set_current_line(85, ng0);
    t1 = (t0 + 2156U);
    t3 = *((char **)t1);
    t2 = *((unsigned char *)t3);
    t1 = (t0 + 4408);
    t4 = (t1 + 32U);
    t8 = *((char **)t4);
    t9 = (t8 + 40U);
    t10 = *((char **)t9);
    *((unsigned char *)t10) = t2;
    xsi_driver_first_trans_fast(t1);
    xsi_set_current_line(86, ng0);
    t1 = (t0 + 2248U);
    t3 = *((char **)t1);
    t2 = *((unsigned char *)t3);
    t1 = (t0 + 4444);
    t4 = (t1 + 32U);
    t8 = *((char **)t4);
    t9 = (t8 + 40U);
    t10 = *((char **)t9);
    *((unsigned char *)t10) = t2;
    xsi_driver_first_trans_fast(t1);
    xsi_set_current_line(87, ng0);
    t1 = (t0 + 1788U);
    t3 = *((char **)t1);
    t2 = *((unsigned char *)t3);
    t1 = (t0 + 4480);
    t4 = (t1 + 32U);
    t8 = *((char **)t4);
    t9 = (t8 + 40U);
    t10 = *((char **)t9);
    *((unsigned char *)t10) = t2;
    xsi_driver_first_trans_fast(t1);
    xsi_set_current_line(89, ng0);
    t1 = (t0 + 2432U);
    t3 = *((char **)t1);
    t1 = (t0 + 4516);
    t4 = (t1 + 32U);
    t8 = *((char **)t4);
    t9 = (t8 + 40U);
    t10 = *((char **)t9);
    memcpy(t10, t3, 16U);
    xsi_driver_first_trans_fast(t1);
    xsi_set_current_line(90, ng0);
    t1 = (t0 + 2616U);
    t3 = *((char **)t1);
    t1 = (t0 + 4552);
    t4 = (t1 + 32U);
    t8 = *((char **)t4);
    t9 = (t8 + 40U);
    t10 = *((char **)t9);
    memcpy(t10, t3, 16U);
    xsi_driver_first_trans_fast(t1);
    xsi_set_current_line(92, ng0);
    t1 = (t0 + 2800U);
    t3 = *((char **)t1);
    t2 = *((unsigned char *)t3);
    t1 = (t0 + 4588);
    t4 = (t1 + 32U);
    t8 = *((char **)t4);
    t9 = (t8 + 40U);
    t10 = *((char **)t9);
    *((unsigned char *)t10) = t2;
    xsi_driver_first_trans_fast(t1);
    goto LAB3;

}

static void work_a_1946541565_3212880686_p_3(char *t0)
{
    char *t1;
    char *t2;
    unsigned char t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    unsigned char t8;
    int t9;
    unsigned int t10;
    unsigned int t11;
    unsigned int t12;
    unsigned char t13;
    int t14;
    unsigned int t15;
    unsigned int t16;
    unsigned int t17;
    unsigned char t18;
    unsigned char t19;
    int t20;
    unsigned int t21;
    unsigned int t22;
    unsigned int t23;
    unsigned char t24;
    char *t25;
    char *t26;
    int t27;
    unsigned int t28;
    unsigned int t29;
    unsigned int t30;
    unsigned char t31;
    unsigned char t32;
    char *t33;
    char *t34;
    int t35;
    unsigned int t36;
    unsigned int t37;
    unsigned int t38;
    unsigned char t39;
    char *t40;
    char *t41;
    int t42;
    unsigned int t43;
    unsigned int t44;
    unsigned int t45;
    unsigned char t46;
    unsigned char t47;
    char *t48;
    char *t49;
    int t50;
    unsigned int t51;
    unsigned int t52;
    unsigned int t53;
    unsigned char t54;
    char *t55;
    char *t56;
    char *t57;
    char *t58;
    char *t59;

LAB0:    xsi_set_current_line(101, ng0);
    t1 = (t0 + 1604U);
    t2 = *((char **)t1);
    t3 = *((unsigned char *)t2);
    t1 = (t0 + 4624);
    t4 = (t1 + 32U);
    t5 = *((char **)t4);
    t6 = (t5 + 40U);
    t7 = *((char **)t6);
    *((unsigned char *)t7) = t3;
    xsi_driver_first_trans_fast(t1);
    xsi_set_current_line(102, ng0);
    t1 = (t0 + 1328U);
    t2 = *((char **)t1);
    t9 = (4 - 7);
    t10 = (t9 * -1);
    t11 = (1U * t10);
    t12 = (0 + t11);
    t1 = (t2 + t12);
    t13 = *((unsigned char *)t1);
    t4 = (t0 + 1328U);
    t5 = *((char **)t4);
    t14 = (5 - 7);
    t15 = (t14 * -1);
    t16 = (1U * t15);
    t17 = (0 + t16);
    t4 = (t5 + t17);
    t18 = *((unsigned char *)t4);
    t19 = (t13 == t18);
    if (t19 == 1)
        goto LAB8;

LAB9:    t8 = (unsigned char)0;

LAB10:    if (t8 == 1)
        goto LAB5;

LAB6:    t3 = (unsigned char)0;

LAB7:    if (t3 != 0)
        goto LAB2;

LAB4:
LAB3:    xsi_set_current_line(106, ng0);
    t1 = (t0 + 1696U);
    t2 = *((char **)t1);
    t3 = *((unsigned char *)t2);
    t1 = (t0 + 4660);
    t4 = (t1 + 32U);
    t5 = *((char **)t4);
    t6 = (t5 + 40U);
    t7 = *((char **)t6);
    *((unsigned char *)t7) = t3;
    xsi_driver_first_trans_fast(t1);
    xsi_set_current_line(107, ng0);
    t1 = (t0 + 1420U);
    t2 = *((char **)t1);
    t9 = (4 - 7);
    t10 = (t9 * -1);
    t11 = (1U * t10);
    t12 = (0 + t11);
    t1 = (t2 + t12);
    t13 = *((unsigned char *)t1);
    t4 = (t0 + 1420U);
    t5 = *((char **)t4);
    t14 = (5 - 7);
    t15 = (t14 * -1);
    t16 = (1U * t15);
    t17 = (0 + t16);
    t4 = (t5 + t17);
    t18 = *((unsigned char *)t4);
    t19 = (t13 == t18);
    if (t19 == 1)
        goto LAB17;

LAB18:    t8 = (unsigned char)0;

LAB19:    if (t8 == 1)
        goto LAB14;

LAB15:    t3 = (unsigned char)0;

LAB16:    if (t3 != 0)
        goto LAB11;

LAB13:
LAB12:    xsi_set_current_line(111, ng0);
    t1 = (t0 + 1788U);
    t2 = *((char **)t1);
    t3 = *((unsigned char *)t2);
    t1 = (t0 + 4696);
    t4 = (t1 + 32U);
    t5 = *((char **)t4);
    t6 = (t5 + 40U);
    t7 = *((char **)t6);
    *((unsigned char *)t7) = t3;
    xsi_driver_first_trans_fast(t1);
    xsi_set_current_line(112, ng0);
    t1 = (t0 + 1512U);
    t2 = *((char **)t1);
    t9 = (4 - 7);
    t10 = (t9 * -1);
    t11 = (1U * t10);
    t12 = (0 + t11);
    t1 = (t2 + t12);
    t13 = *((unsigned char *)t1);
    t4 = (t0 + 1512U);
    t5 = *((char **)t4);
    t14 = (5 - 7);
    t15 = (t14 * -1);
    t16 = (1U * t15);
    t17 = (0 + t16);
    t4 = (t5 + t17);
    t18 = *((unsigned char *)t4);
    t19 = (t13 == t18);
    if (t19 == 1)
        goto LAB26;

LAB27:    t8 = (unsigned char)0;

LAB28:    if (t8 == 1)
        goto LAB23;

LAB24:    t3 = (unsigned char)0;

LAB25:    if (t3 != 0)
        goto LAB20;

LAB22:
LAB21:    xsi_set_current_line(116, ng0);
    t1 = (t0 + 2340U);
    t2 = *((char **)t1);
    t1 = (t0 + 4732);
    t4 = (t1 + 32U);
    t5 = *((char **)t4);
    t6 = (t5 + 40U);
    t7 = *((char **)t6);
    memcpy(t7, t2, 16U);
    xsi_driver_first_trans_fast(t1);
    xsi_set_current_line(117, ng0);
    t1 = (t0 + 2524U);
    t2 = *((char **)t1);
    t1 = (t0 + 4768);
    t4 = (t1 + 32U);
    t5 = *((char **)t4);
    t6 = (t5 + 40U);
    t7 = *((char **)t6);
    memcpy(t7, t2, 16U);
    xsi_driver_first_trans_fast(t1);
    xsi_set_current_line(119, ng0);
    t1 = (t0 + 1604U);
    t2 = *((char **)t1);
    t3 = *((unsigned char *)t2);
    t8 = (t3 == (unsigned char)2);
    if (t8 != 0)
        goto LAB29;

LAB31:    xsi_set_current_line(130, ng0);
    t1 = (t0 + 684U);
    t2 = *((char **)t1);
    t1 = (t0 + 4768);
    t4 = (t1 + 32U);
    t5 = *((char **)t4);
    t6 = (t5 + 40U);
    t7 = *((char **)t6);
    memcpy(t7, t2, 16U);
    xsi_driver_first_trans_fast(t1);
    xsi_set_current_line(131, ng0);
    t1 = (t0 + 4804);
    t2 = (t1 + 32U);
    t4 = *((char **)t2);
    t5 = (t4 + 40U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = (unsigned char)4;
    xsi_driver_first_trans_fast_port(t1);

LAB30:    xsi_set_current_line(134, ng0);
    t1 = (t0 + 2708U);
    t2 = *((char **)t1);
    t3 = *((unsigned char *)t2);
    t1 = (t0 + 4840);
    t4 = (t1 + 32U);
    t5 = *((char **)t4);
    t6 = (t5 + 40U);
    t7 = *((char **)t6);
    *((unsigned char *)t7) = t3;
    xsi_driver_first_trans_fast(t1);
    xsi_set_current_line(135, ng0);
    t1 = (t0 + 1972U);
    t2 = *((char **)t1);
    t8 = *((unsigned char *)t2);
    t13 = (t8 == (unsigned char)2);
    if (t13 == 1)
        goto LAB47;

LAB48:    t3 = (unsigned char)0;

LAB49:    if (t3 != 0)
        goto LAB44;

LAB46:
LAB45:    t1 = (t0 + 4112);
    *((int *)t1) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(103, ng0);
    t48 = (t0 + 1328U);
    t49 = *((char **)t48);
    t50 = (4 - 7);
    t51 = (t50 * -1);
    t52 = (1U * t51);
    t53 = (0 + t52);
    t48 = (t49 + t53);
    t54 = *((unsigned char *)t48);
    t55 = (t0 + 4624);
    t56 = (t55 + 32U);
    t57 = *((char **)t56);
    t58 = (t57 + 40U);
    t59 = *((char **)t58);
    *((unsigned char *)t59) = t54;
    xsi_driver_first_trans_fast(t55);
    goto LAB3;

LAB5:    t33 = (t0 + 1328U);
    t34 = *((char **)t33);
    t35 = (6 - 7);
    t36 = (t35 * -1);
    t37 = (1U * t36);
    t38 = (0 + t37);
    t33 = (t34 + t38);
    t39 = *((unsigned char *)t33);
    t40 = (t0 + 1328U);
    t41 = *((char **)t40);
    t42 = (7 - 7);
    t43 = (t42 * -1);
    t44 = (1U * t43);
    t45 = (0 + t44);
    t40 = (t41 + t45);
    t46 = *((unsigned char *)t40);
    t47 = (t39 == t46);
    t3 = t47;
    goto LAB7;

LAB8:    t6 = (t0 + 1328U);
    t7 = *((char **)t6);
    t20 = (5 - 7);
    t21 = (t20 * -1);
    t22 = (1U * t21);
    t23 = (0 + t22);
    t6 = (t7 + t23);
    t24 = *((unsigned char *)t6);
    t25 = (t0 + 1328U);
    t26 = *((char **)t25);
    t27 = (6 - 7);
    t28 = (t27 * -1);
    t29 = (1U * t28);
    t30 = (0 + t29);
    t25 = (t26 + t30);
    t31 = *((unsigned char *)t25);
    t32 = (t24 == t31);
    t8 = t32;
    goto LAB10;

LAB11:    xsi_set_current_line(108, ng0);
    t48 = (t0 + 1420U);
    t49 = *((char **)t48);
    t50 = (4 - 7);
    t51 = (t50 * -1);
    t52 = (1U * t51);
    t53 = (0 + t52);
    t48 = (t49 + t53);
    t54 = *((unsigned char *)t48);
    t55 = (t0 + 4660);
    t56 = (t55 + 32U);
    t57 = *((char **)t56);
    t58 = (t57 + 40U);
    t59 = *((char **)t58);
    *((unsigned char *)t59) = t54;
    xsi_driver_first_trans_fast(t55);
    goto LAB12;

LAB14:    t33 = (t0 + 1420U);
    t34 = *((char **)t33);
    t35 = (6 - 7);
    t36 = (t35 * -1);
    t37 = (1U * t36);
    t38 = (0 + t37);
    t33 = (t34 + t38);
    t39 = *((unsigned char *)t33);
    t40 = (t0 + 1420U);
    t41 = *((char **)t40);
    t42 = (7 - 7);
    t43 = (t42 * -1);
    t44 = (1U * t43);
    t45 = (0 + t44);
    t40 = (t41 + t45);
    t46 = *((unsigned char *)t40);
    t47 = (t39 == t46);
    t3 = t47;
    goto LAB16;

LAB17:    t6 = (t0 + 1420U);
    t7 = *((char **)t6);
    t20 = (5 - 7);
    t21 = (t20 * -1);
    t22 = (1U * t21);
    t23 = (0 + t22);
    t6 = (t7 + t23);
    t24 = *((unsigned char *)t6);
    t25 = (t0 + 1420U);
    t26 = *((char **)t25);
    t27 = (6 - 7);
    t28 = (t27 * -1);
    t29 = (1U * t28);
    t30 = (0 + t29);
    t25 = (t26 + t30);
    t31 = *((unsigned char *)t25);
    t32 = (t24 == t31);
    t8 = t32;
    goto LAB19;

LAB20:    xsi_set_current_line(113, ng0);
    t48 = (t0 + 1512U);
    t49 = *((char **)t48);
    t50 = (4 - 7);
    t51 = (t50 * -1);
    t52 = (1U * t51);
    t53 = (0 + t52);
    t48 = (t49 + t53);
    t54 = *((unsigned char *)t48);
    t55 = (t0 + 4696);
    t56 = (t55 + 32U);
    t57 = *((char **)t56);
    t58 = (t57 + 40U);
    t59 = *((char **)t58);
    *((unsigned char *)t59) = t54;
    xsi_driver_first_trans_fast(t55);
    goto LAB21;

LAB23:    t33 = (t0 + 1512U);
    t34 = *((char **)t33);
    t35 = (6 - 7);
    t36 = (t35 * -1);
    t37 = (1U * t36);
    t38 = (0 + t37);
    t33 = (t34 + t38);
    t39 = *((unsigned char *)t33);
    t40 = (t0 + 1512U);
    t41 = *((char **)t40);
    t42 = (7 - 7);
    t43 = (t42 * -1);
    t44 = (1U * t43);
    t45 = (0 + t44);
    t40 = (t41 + t45);
    t46 = *((unsigned char *)t40);
    t47 = (t39 == t46);
    t3 = t47;
    goto LAB25;

LAB26:    t6 = (t0 + 1512U);
    t7 = *((char **)t6);
    t20 = (5 - 7);
    t21 = (t20 * -1);
    t22 = (1U * t21);
    t23 = (0 + t22);
    t6 = (t7 + t23);
    t24 = *((unsigned char *)t6);
    t25 = (t0 + 1512U);
    t26 = *((char **)t25);
    t27 = (6 - 7);
    t28 = (t27 * -1);
    t29 = (1U * t28);
    t30 = (0 + t29);
    t25 = (t26 + t30);
    t31 = *((unsigned char *)t25);
    t32 = (t24 == t31);
    t8 = t32;
    goto LAB28;

LAB29:    xsi_set_current_line(120, ng0);
    t1 = (t0 + 1880U);
    t4 = *((char **)t1);
    t18 = *((unsigned char *)t4);
    t19 = (t18 == (unsigned char)2);
    if (t19 == 1)
        goto LAB35;

LAB36:    t13 = (unsigned char)0;

LAB37:    if (t13 != 0)
        goto LAB32;

LAB34:
LAB33:    xsi_set_current_line(125, ng0);
    t1 = (t0 + 2524U);
    t2 = *((char **)t1);
    t9 = (15 - 15);
    t10 = (t9 * -1);
    t11 = (1U * t10);
    t12 = (0 + t11);
    t1 = (t2 + t12);
    t3 = *((unsigned char *)t1);
    t4 = (t0 + 4804);
    t5 = (t4 + 32U);
    t6 = *((char **)t5);
    t7 = (t6 + 40U);
    t25 = *((char **)t7);
    *((unsigned char *)t25) = t3;
    xsi_driver_first_trans_fast_port(t4);
    xsi_set_current_line(126, ng0);
    t1 = (t0 + 1880U);
    t2 = *((char **)t1);
    t8 = *((unsigned char *)t2);
    t13 = (t8 == (unsigned char)2);
    if (t13 == 1)
        goto LAB41;

LAB42:    t3 = (unsigned char)0;

LAB43:    if (t3 != 0)
        goto LAB38;

LAB40:
LAB39:    goto LAB30;

LAB32:    xsi_set_current_line(121, ng0);
    t1 = (t0 + 1696U);
    t6 = *((char **)t1);
    t32 = *((unsigned char *)t6);
    t1 = (t0 + 4732);
    t7 = (t1 + 32U);
    t25 = *((char **)t7);
    t26 = (t25 + 40U);
    t33 = *((char **)t26);
    *((unsigned char *)t33) = t32;
    xsi_driver_first_trans_delta(t1, 15U, 1, 0LL);
    xsi_set_current_line(122, ng0);
    t1 = (t0 + 2340U);
    t2 = *((char **)t1);
    t10 = (15 - 14);
    t11 = (t10 * 1U);
    t12 = (0 + t11);
    t1 = (t2 + t12);
    t4 = (t0 + 4732);
    t5 = (t4 + 32U);
    t6 = *((char **)t5);
    t7 = (t6 + 40U);
    t25 = *((char **)t7);
    memcpy(t25, t1, 15U);
    xsi_driver_first_trans_delta(t4, 0U, 15U, 0LL);
    goto LAB33;

LAB35:    t1 = (t0 + 1788U);
    t5 = *((char **)t1);
    t24 = *((unsigned char *)t5);
    t31 = (t24 == (unsigned char)3);
    t13 = t31;
    goto LAB37;

LAB38:    xsi_set_current_line(127, ng0);
    t1 = (t0 + 2524U);
    t5 = *((char **)t1);
    t10 = (15 - 14);
    t11 = (t10 * 1U);
    t12 = (0 + t11);
    t1 = (t5 + t12);
    t6 = (t0 + 4768);
    t7 = (t6 + 32U);
    t25 = *((char **)t7);
    t26 = (t25 + 40U);
    t33 = *((char **)t26);
    memcpy(t33, t1, 15U);
    xsi_driver_first_trans_delta(t6, 0U, 15U, 0LL);
    goto LAB39;

LAB41:    t1 = (t0 + 1788U);
    t4 = *((char **)t1);
    t18 = *((unsigned char *)t4);
    t19 = (t18 == (unsigned char)3);
    t3 = t19;
    goto LAB43;

LAB44:    xsi_set_current_line(136, ng0);
    t1 = (t0 + 2708U);
    t5 = *((char **)t1);
    t24 = *((unsigned char *)t5);
    t31 = ieee_p_2592010699_sub_1690584930_503743352(IEEE_P_2592010699, t24);
    t1 = (t0 + 4840);
    t6 = (t1 + 32U);
    t7 = *((char **)t6);
    t25 = (t7 + 40U);
    t26 = *((char **)t25);
    *((unsigned char *)t26) = t31;
    xsi_driver_first_trans_fast(t1);
    goto LAB45;

LAB47:    t1 = (t0 + 1604U);
    t4 = *((char **)t1);
    t18 = *((unsigned char *)t4);
    t19 = (t18 == (unsigned char)3);
    t3 = t19;
    goto LAB49;

}


extern void work_a_1946541565_3212880686_init()
{
	static char *pe[] = {(void *)work_a_1946541565_3212880686_p_0,(void *)work_a_1946541565_3212880686_p_1,(void *)work_a_1946541565_3212880686_p_2,(void *)work_a_1946541565_3212880686_p_3};
	xsi_register_didat("work_a_1946541565_3212880686", "isim/bl_isim_beh.exe.sim/work/a_1946541565_3212880686.didat");
	xsi_register_executes(pe);
}
