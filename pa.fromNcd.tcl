
# PlanAhead Launch Script for Post PAR Floorplanning, created by Project Navigator

create_project -name XilinxBurst -dir "C:/GitRepos/XilinxDDRBurst/planAhead_run_3" -part xc6slx16ftg256-2
set srcset [get_property srcset [current_run -impl]]
set_property design_mode GateLvl $srcset
set_property edif_top_file "C:/GitRepos/XilinxDDRBurst/bl_cs.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {C:/GitRepos/XilinxDDRBurst} {ipcore_dir} }
add_files [list {ipcore_dir/FIFOphil2.ncf}] -fileset [get_property constrset [current_run]]
set_property target_constrs_file "bl.ucf" [current_fileset -constrset]
add_files [list {bl.ucf}] -fileset [get_property constrset [current_run]]
link_design
read_xdl -file "C:/GitRepos/XilinxDDRBurst/bl.ncd"
if {[catch {read_twx -name results_1 -file "C:/GitRepos/XilinxDDRBurst/bl.twx"} eInfo]} {
   puts "WARNING: there was a problem importing \"C:/GitRepos/XilinxDDRBurst/bl.twx\": $eInfo"
}
