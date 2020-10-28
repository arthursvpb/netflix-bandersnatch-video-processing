ASSETSFOLDER=assets/timeline
for mediaFile in `ls $ASSETSFOLDER | grep .mp4`; do
    # Cortar a extensão e a resolução do arquivo
    FILENAME=$(echo $mediaFile | sed -n 's/.mp4//p' | sed -n 's/-1920x1080//p')
    INPUT=$ASSETSFOLDER/$mediaFile
    FOLDER_TARGET=$ASSETSFOLDER/$FILENAME
    mkdir -p $FOLDER_TARGET
    
    # Criar arquivos de resoluções diferentes na pasta
    OUTPUT=$ASSETSFOLDER/$FILENAME/$FILENAME
    DURATION=$(ffprobe -i $INPUT -show_format -v quiet | sed -n 's/duration=//p')

    OUTPUT144=$OUTPUT-$DURATION-144
    OUTPUT360=$OUTPUT-$DURATION-360
    OUTPUT720=$OUTPUT-$DURATION-720

    # Renderizar
    echo 'rendering in 720p'
    ffmpeg -y -i $INPUT \
        -c:a aac -ac 2 \
        -vcodec h264 -acodec aac \
        -ab 128k \
        -movflags frag_keyframe+empty_moov+default_base_moof \
        -b:v 1500k \
        -maxrate 1500k \
        -bufsize 1000k \
        -vf "scale=-1:720" \
        # -v quiet \
        # stoped class at 21:00 with problems on script
        $OUTPUT720.mp4
done