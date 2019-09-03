using terms from application "Mail"
  on perform mail action with messages theMessages for rule theRule
    tell application "Mail"
      repeat with eachMessage in theMessages
        -- wrap in try to catch errors and display them
        try
          repeat with theAttachment in eachMessage's mail attachments
            -- get name of attachment and proceed if winmail.dat
            set originalName to name of theAttachment
            if originalName is equal to "winmail.dat" then
              -- build path to save file
              set downloadsFolder to (((path to home folder) as rich text) & "Downloads") as rich text
              set savePath to (downloadsFolder & ":" & originalName)
              -- find unique name
              set pathIterator to 1
              tell application "Finder"
                repeat while exists file savePath
                  set savePath to (downloadsFolder & ":winmail-" & pathIterator & ".dat")
                  set pathIterator to pathIterator + 1
                end repeat
              end tell
              -- save file
              save theAttachment in savePath
              -- open file
              tell application "Finder"
                open savePath using application file id "com.joshjacob.TNEFsEnough"
              end tell
            end if
          end repeat
        on error theerror
          display dialog theerror buttons {"Ok"} default button 1
        end try
      end repeat
    end tell
  end perform mail action with messages
end using terms from
