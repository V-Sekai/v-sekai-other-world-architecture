taskTemplate: {
	arguments: [...]
	command: "/bin/bash"
	type:    "exec"
}

environment_variables: [{
	name:  "GODOT_STATUS"
	value: "groups-4.3"
}]
group:          "gamma"
label_template: "groups-4.3.${godot-groups-editor_pipeline_dependency}.${COUNT}"
materials: [{
	branch:      "main"
	destination: "g"
	name:        "project_git_sandbox"
	type:        "git"
	url:         "https://github.com/V-Sekai/v-sekai-game.git"
}, {
	ignore_for_scheduling: false
	name:                  "godot-groups-editor_pipeline_dependency"
	pipeline:              "godot-groups"
	stage:                 "templateZipStage"
	type:                  "dependency"
}]
name: "groups-editor-export"
stages: [{
	clean_workspace: true
	fetch_materials: true
	jobs: [{
		artifacts: [{
			destination: ""
			source:      "export_windows"
			type:        "build"
		}]
		name: "windows_job"
		resources: ["linux", "mingw5"]
		tasks: [{
			artifact_origin:  "gocd"
			destination:      ""
			is_source_a_file: true
			job:              "defaultJob"
			pipeline:         "godot-groups"
			source:           "godot.templates.tpz"
			stage:            "templateZipStage"
			type:             "fetch"
		}, {
			artifact_origin:  "gocd"
			destination:      ""
			is_source_a_file: true
			job:              "linux_job"
			pipeline:         "godot-groups"
			source:           "godot.linuxbsd.editor.double.x86_64.llvm"
			stage:            "defaultStage"
			type:             "fetch"
		}, {
			artifact_origin:  "gocd"
			destination:      ""
			is_source_a_file: true
			job:              "linux_job"
			pipeline:         "godot-groups"
			source:           "godot.linuxbsd.editor.double.x86_64.llvm"
			stage:            "defaultStage"
			type:             "fetch"
		}, taskTemplate & {
			arguments: ["-c", "rm -rf templates && unzip \"godot.templates.tpz\" && export VERSION=\"`cat templates/version.txt`\" && export TEMPLATEDIR=\".local/share/godot/export_templates/$VERSION/\" && export HOME=\"`pwd`\" && export BASEDIR=\"`pwd`\" && rm -rf \"$TEMPLATEDIR\" && mkdir -p \"$TEMPLATEDIR\" && cd \"$TEMPLATEDIR\" && mv \"$BASEDIR\"/templates/* ."]
		}, taskTemplate & {
			arguments: ["-c", "(echo \"## AUTOGENERATED BY BUILD\"; echo \"\"; echo \"const BUILD_LABEL = \\\"$GO_PIPELINE_LABEL\\\"\"; echo \"const BUILD_DATE_STR = \\\"$(date --utc --iso=seconds)\\\"\"; echo \"const BUILD_UNIX_TIME = $(date +%s)\" ) > addons/vsk_version/build_constants.gd"]
			working_directory: "g"
		}, taskTemplate & {
			arguments: ["-c", "rm -rf export_windows"]
		}, taskTemplate & {
			arguments: ["-c", "mkdir export_windows"]
		}, taskTemplate & {
			arguments: ["-c", "chmod +x godot.linuxbsd.editor.double.x86_64.llvm"]
		}, taskTemplate & {
			arguments: ["-c", "ls templates"]
		}, taskTemplate & {
			arguments: ["-c", "unzip godot.templates.tpz"]
		}, taskTemplate & {
			arguments: ["-c", "cp templates/windows_release_x86_64.exe export_windows/v_sekai_windows.exe"]
		}, taskTemplate & {
			arguments: ["-c", "ls export_windows"]
		}]
	}, {
		artifacts: [{
			destination: ""
			source:      "export_linuxbsd"
			type:        "build"
		}]
		name: "linux_job"
		resources: ["linux", "mingw5"]
		tasks: [{
				artifact_origin:  "gocd"
				destination:      ""
				is_source_a_file: true
				job:              "defaultJob"
				pipeline:         "godot-groups"
				source:           "godot.templates.tpz"
				stage:            "templateZipStage"
				type:             "fetch"
			}, {
					artifact_origin:  "gocd"
					destination:      ""
					is_source_a_file: true
					job:              "linux_job"
					pipeline:         "godot-groups"
					source:           "godot.linuxbsd.editor.double.x86_64.llvm"
					stage:            "defaultStage"
					type:             "fetch"
			}, {
					artifact_origin:  "gocd"
					destination:      ""
					is_source_a_file: true
					job:              "linux_job"
					pipeline:         "godot-groups"
					source:           "godot.linuxbsd.editor.double.x86_64.llvm"
					stage:            "defaultStage"
					type:             "fetch"
			},
			taskTemplate & {
				arguments: ["-c", "rm -rf templates && unzip \"godot.templates.tpz\" && export VERSION=\"`cat templates/version.txt`\" && export TEMPLATEDIR=\".local/share/godot/export_templates/$VERSION/\" && export HOME=\"`pwd`\" && export BASEDIR=\"`pwd`\" && rm -rf \"$TEMPLATEDIR\" && mkdir -p \"$TEMPLATEDIR\" && cd \"$TEMPLATEDIR\" && mv \"$BASEDIR\"/templates/* ."]
				working_directory: ""
			},
			taskTemplate & {
				arguments: ["-c", "(echo \"## AUTOGENERATED BY BUILD\"; echo \"\"; echo \"const BUILD_LABEL = \\\"$GO_PIPELINE_LABEL\\\"\"; echo \"const BUILD_DATE_STR = \\\"$(date --utc --iso=seconds)\\\"\"; echo \"const BUILD_UNIX_TIME = $(date +%s)\" ) > addons/vsk_version/build_constants.gd"]
				working_directory: "g"
			},
			taskTemplate & {
				arguments: ["-c", "rm -rf export_linuxbsd"]
				working_directory: ""
			},
			taskTemplate & {
				arguments: ["-c", "mkdir export_linuxbsd"]
				working_directory: ""
			},
			taskTemplate & {
				arguments: ["-c", "chmod +x godot.linuxbsd.editor.double.x86_64.llvm"]
				working_directory: ""
			},
			taskTemplate & {
				arguments: ["-c", "ls templates"]
				working_directory: ""
			},
			taskTemplate & {
				arguments: ["-c", "unzip godot.templates.tpz"]
				working_directory: ""
			},
			taskTemplate & {
				arguments: ["-c", "cp templates/linux_release.x86_64 export_linuxbsd/v_sekai_linuxbsd"]
				working_directory: ""
			},
			taskTemplate & {
				arguments: ["-c", "cp templates/linux_release.x86_64 export_linuxbsd/v_sekai_linuxbsd"]
				working_directory: ""
			},
			taskTemplate & {
				arguments: ["-c", "ls export_linuxbsd"]
				working_directory: ""
			}
		]
	}]
	name: "exportStage"
}, {
	clean_workspace: false
	jobs: [{
		name: "windows_job"
		resources: ["linux", "mingw5"]
		tasks: [{
			artifact_origin:  "gocd"
			destination:      ""
			is_source_a_file: false
			job:              "windows_job"
			pipeline:         "groups-editor-export"
			source:           "export_windows"
			stage:            "exportStage"
			type:             "fetch"
		}, taskTemplate & {
			arguments: ["-c", "mkdir -p export/game"]
		}, taskTemplate & {
			arguments: ["-c", "mkdir -p export/editor"]
		}, taskTemplate & {
			arguments: ["-c", "mv export_windows/* export/game"]
		}, {
			artifact_origin:  "gocd"
			destination:      ""
			is_source_a_file: false
			job:              "windows_job"
			pipeline:         "groups-editor-export"
			source:           "export_windows"
			stage:            "exportStage"
			type:             "fetch"
		}, taskTemplate & {
			arguments: ["-c", "mv export_windows/v_sekai_windows.exe export/editor/v_sekai_windows_editor.exe"]
		}, taskTemplate & {
			arguments: ["-c", """
			cat > export/.itch.toml <<EOF
			[[actions]]
			name = "play"
			path = "game/v_sekai_windows.exe"

			[[actions]]
			name = "Desktop"
			path = "game/v_sekai_windows.exe"
			args = ["--xr-mode", "off"]

			[[actions]]
			name = "editor"
			path = "editor/v_sekai_windows_editor.exe"
			platform = "windows"

			[[actions]]
			name = "forums"
			path = "https://discord.gg/7BQDHesck8"

			[[actions]]
			name = "Manuals"
			path = "https://v-sekai.github.io/manuals/"
			EOF
			"""]
		}, taskTemplate & {
			arguments: ["-c", "butler push export ifiregames/v-sekai-editor:windows-master --userversion $GO_PIPELINE_LABEL-`date --iso=seconds --utc`"]
		}]
	}, {
		name: "linux_job"
		resources: ["linux", "mingw5"]
		tasks: [{
			artifact_origin:  "gocd"
			destination:      ""
			is_source_a_file: false
			job:              "linux_job"
			pipeline:         "groups-editor-export"
			source:           "export_linuxbsd"
			stage:            "exportStage"
			type:             "fetch"
		}, taskTemplate & {
			arguments: ["-c", "mkdir -p export/game"]
		}, taskTemplate & {
			arguments: ["-c", "mkdir -p export/editor"]
		}, taskTemplate & {
			arguments: ["-c", "mv export_linuxbsd/* export/game"]
		}, {
			artifact_origin:  "gocd"
			destination:      ""
			is_source_a_file: false
			job:              "linux_job"
			pipeline:         "groups-editor-export"
			source:           "export_linuxbsd"
			stage:            "exportStage"
			type:             "fetch"
		}, taskTemplate & {
			arguments: ["-c", "mv export_linuxbsd/v_sekai_linuxbsd export/editor/v_sekai_linuxbsd_editor"]
		}, taskTemplate & {
			arguments: ["-c", """
				cat > export/.itch.toml <<EOF
				[[actions]]
				name = "play"
				path = "game/v_sekai_linuxbsd"

				[[actions]]
				name = "Desktop"
				path = "game/v_sekai_linuxbsd"
				args = ["--xr-mode", "off"]

				[[actions]]
				name = "editor"
				path = "editor/v_sekai_linuxbsd_editor"
				platform = "linux"

				[[actions]]
				name = "Forums"
				path = "https://discord.gg/7BQDHesck8"

				[[actions]]
				name = "Manuals"
				path = "https://v-sekai.github.io/manuals/"
				EOF
				"""]
		}, taskTemplate & {
			arguments: ["-c", "butler push export ifiregames/v-sekai-editor:linux-master --userversion $GO_PIPELINE_LABEL-`date --iso=seconds --utc`"]
		}]
	}]
	name: "uploadStage"
}]
