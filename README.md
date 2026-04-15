Findings:

* DWARFS has worse zsync efficiency than SQUASHFS, this is mainly due to Nilsimsa ordering, 

<img width="424" height="321" alt="image" src="https://github.com/user-attachments/assets/5f2f909b-c896-4b6f-bd7a-409c64de5d06" />

* Running `mkdwarfs` with `--order=path` which removes Nilsimsa ordering improves the efficiency a lot **(from 18% to 68%)**.

<img width="447" height="307" alt="image" src="https://github.com/user-attachments/assets/d7192785-befb-4fd3-a39e-795df4db4cd3" />

* Block size and ocompression level doesn't really change the zsync efficiency.

---

* `zstd10` with `-S20` (1MIB blocks) doesn't really increase the launch speed. You are better off always using `zstd22` and `-S26` (64 MIB blocks).

<img width="556" height="219" alt="image" src="https://github.com/user-attachments/assets/c7abe7f1-d970-4752-9daf-6ae7b7ebfe28" />
