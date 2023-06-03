use framework "IOBluetooth"
use scripting additions

set AirPodsName to "NewxcµÄAirPods Pro2"
set SpeakersName to "MacBook ProÑïÉùÆ÷"

on getFirstMatchingDevice(deviceName)
	repeat with device in (current application's IOBluetoothDevice's pairedDevices() as list)
		if (device's nameOrAddress as string) contains deviceName then return device
	end repeat
end getFirstMatchingDevice

on toggleDevice(device)
	set quotedDeviceName to quoted form of (device's nameOrAddress as string)
	
	if not (device's isConnected as boolean) then
		device's openConnection()
	end if
	
	do shell script "/opt/homebrew/Cellar/switchaudio-osx/1.2.2/SwitchAudioSource -s " & quotedDeviceName
	return "Connecting " & (device's nameOrAddress as string)
end toggleDevice

-- get the current output device name
set currentOutput to do shell script "/opt/homebrew/Cellar/switchaudio-osx/1.2.2/SwitchAudioSource -c"

-- if it is the AirPods, switch to the Speakers
if currentOutput contains AirPodsName then
	do shell script "/opt/homebrew/Cellar/switchaudio-osx/1.2.2/SwitchAudioSource -s " & quoted form of SpeakersName
	return "Switching to " & SpeakersName
else -- otherwise, switch to the AirPods
	set resultMessage to toggleDevice(getFirstMatchingDevice(AirPodsName))
	if resultMessage contains "Connecting" then
		do shell script "afplay /System/Library/Sounds/Ping.aiff"
	end if
	return resultMessage
end if