@@
expression card;
@@
- snd_card_free(card)
+ (snd_card_free(card), 0)
