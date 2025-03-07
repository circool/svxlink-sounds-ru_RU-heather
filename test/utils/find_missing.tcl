#!/usr/bin/env tclsh
# Ищет отсутствующие файлы в директории и выводит их в stdout, создает их в другой директории, формирует отчет о недостающих файлах.

proc find_files {path recursive} {
	set files {}
	if {![file exists $path]} {
		puts stderr "Warning: $path does not exist, skipping."
		return $files
	}
	if {![file isdirectory $path]} {
		puts stderr "Error: $path is not a directory"
		exit 1
	}
	if {$recursive} {
		set files [glob -nocomplain -directory $path -types f -tails -- *]
		foreach dir [glob -nocomplain -directory $path -types d -- *] {
			set subfiles [find_files [file join $path $dir] $recursive]
			foreach f $subfiles {
				lappend files [file join $dir $f]
			}
		}
	} else {
		set files [glob -nocomplain -directory $path -types f -tails -- *]
	}
	return $files
}

proc get_file_name_without_extension {filename} {
	return [file rootname [file tail $filename]]
}

proc get_common_extension {files} {
	set extensions {}
	foreach file $files {
		lappend extensions [file extension $file]
	}
	set unique_extensions [lsort -unique $extensions]
	if {[llength $unique_extensions] == 1} {
		return [lindex $unique_extensions 0]
	}
	return ""
}

proc create_missing_files {missing_pairs path1 path2 create_in} {
	set target_path ""
	set source_path ""
	set created_files {}

	if {$create_in == 1} {
		set target_path $path1
		set source_path $path2
	} elseif {$create_in == 2} {
		set target_path $path2
		set source_path $path1
	} else {
		puts stderr "Error: Invalid value for -c option. Use -c1 or -c2."
		exit 1
	}

	foreach pair $missing_pairs {
		set file1 [lindex $pair 0]
		set file2 [lindex $pair 1]

		if {$create_in == 1 && $file1 eq ""} {
			set source_file [file join $source_path $file2]
			set target_dir [file dirname [file join $target_path $file2]]
			set target_files [find_files $target_dir 0]
			set target_extension [get_common_extension $target_files]

			if {$target_extension eq ""} {
				puts stderr "Warning: Cannot determine common file extension in $target_dir. Skipping."
				continue
			}

			set target_file [file join $target_path [file rootname $file2]$target_extension]
			if {![file exists $target_file]} {
				puts "Creating $target_file"
				close [open $target_file w]
				lappend created_files $target_file
			}
		} elseif {$create_in == 2 && $file2 eq ""} {
			set source_file [file join $source_path $file1]
			set target_dir [file dirname [file join $target_path $file1]]
			set target_files [find_files $target_dir 0]
			set target_extension [get_common_extension $target_files]

			if {$target_extension eq ""} {
				puts stderr "Warning: Cannot determine common file extension in $target_dir. Skipping."
				continue
			}

			set target_file [file join $target_path [file rootname $file1]$target_extension]
			if {![file exists $target_file]} {
				puts "Creating $target_file"
				close [open $target_file w]
				lappend created_files $target_file
			}
		}
	}

	# Записываем список созданных файлов в missing.txt
	if {[llength $created_files] > 0} {
		set missing_file [file join $target_path "missing.txt"]
		set missing_fh [open $missing_file w]
		foreach file $created_files {
			puts $missing_fh $file
		}
		close $missing_fh
		puts "Created $missing_file with list of created files."
	}
}

proc find_missing {path1 path2 recursive} {
	set files1 [find_files $path1 $recursive]
	set files2 [find_files $path2 $recursive]

	set names1 {}
	foreach file $files1 {
		lappend names1 [get_file_name_without_extension $file]
	}

	set names2 {}
	foreach file $files2 {
		lappend names2 [get_file_name_without_extension $file]
	}

	set missing_pairs {}
	foreach file $files1 {
		set name [get_file_name_without_extension $file]
		if {$name ni $names2} {
			lappend missing_pairs [list $file ""]
		}
	}

	foreach file $files2 {
		set name [get_file_name_without_extension $file]
		if {$name ni $names1} {
			lappend missing_pairs [list "" $file]
		}
	}

	return $missing_pairs
}

proc main {argv} {
	set recursive 0
	set create_in 0
	set paths {}

	for {set i 0} {$i < [llength $argv]} {incr i} {
		set arg [lindex $argv $i]
		if {$arg eq "-r"} {
			set recursive 1
		} elseif {[string match "-c*" $arg]} {
			set create_in [string index $arg 2]
			if {$create_in ni {1 2}} {
				puts stderr "Error: Invalid value for -c option. Use -c1 or -c2."
				exit 1
			}
		} else {
			lappend paths $arg
		}
	}

	if {[llength $paths] != 2} {
		puts stderr "Usage: find_missing.tcl \[-r\] \[-c<1|2>\] path1 path2"
		exit 1
	}

	set path1 [lindex $paths 0]
	set path2 [lindex $paths 1]

	set missing_pairs [find_missing $path1 $path2 $recursive]

	if {$create_in != 0} {
		create_missing_files $missing_pairs $path1 $path2 $create_in
	} else {
		foreach pair $missing_pairs {
			set file1 [lindex $pair 0]
			set file2 [lindex $pair 1]
			if {$file1 eq ""} {
				puts "Missing in $path1: $file2"
			} else {
				puts "Missing in $path2: $file1"
			}
		}
	}
}

main $argv