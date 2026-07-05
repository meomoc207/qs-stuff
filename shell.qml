//@ pragma UseQApplication
import Quickshell
import Quickshell.Io
import "modules/bar"
import "modules/notifications"
import "modules/launcher"
ShellRoot {
    IpcHandler {
	target: "launcher"
	function toggle(): void {
	    LauncherState.toggle()
	}
    }
    Variants {
        model: Quickshell.screens
        Bar { modelData: modelData }
    }
    Variants {
	model: Quickshell.screens
	PopupLayer { modelData: modeldata }
    }
    Variants {
	model: Quickshell.screens
	HistoryPanel { modelData: modelData }
    }
    Variants {
	model: Quickshell.screens
	Launcher { modelData: modelData }
    }
}
