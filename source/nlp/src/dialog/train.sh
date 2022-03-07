fairseq-train \ data/chatbot-bin \
--arch lstm \
--share-decoder-input-output-embed \
--optimizer adam \
--lr 1.0e-3 \
--max-tokens 4096 \
--save-dir data/chatbot-cp