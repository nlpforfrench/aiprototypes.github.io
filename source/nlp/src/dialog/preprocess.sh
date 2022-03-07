fairseq-preprocess \
--source-lang fr \
--target-lang en \
--trainpref data/chatbot/selfdialog.train.tok \
--validpref data/chatbot/selfdialog.valid.tok \
--destdir data/chatbot-bin \
--thresholdsrc 3 \
--thresholdtgt 3