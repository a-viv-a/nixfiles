function ffmpeg_aac
    set transcode_list ".flac" ".alac"

    set target $(path resolve $argv[1])/
    
    set origin $HOME/music/
    echo rewriting $origin to $target for files in input
    echo configured to transcode: $transcode_list
    echo

    for file in $argv[2..-1]
        set name $(path basename $file)
        set file_path $(path resolve $file)
        set target_path $(string replace $origin $target $file_path)

        echo "==== $name ===="

        echo -e "path:\t$file_path"

        function prep -S
            echo -e "target:\t$target_path"
            mkdir -p (dirname $target_path)
        end

        if contains (path extension $file) $transcode_list
            
            set target_path (path change-extension m4a $target_path)
            prep
            echo "transcoding! calling ffmpeg..."
            ffmpeg -i $file_path -vn -c:a libfdk_aac -vbr 5 -sample_fmt s16 -ar 44100  $target_path
            echo "done!"
        else 
            prep
            echo "not transcoding due to $(path extension $file) extension. copying..."
            cp $file_path $target_path
            echo "done."
        end
        echo -e "====="$(string replace -ra "." "=" $name)"=====\n\n"
    end
end
