Findings:

* DWARFS has worse zsync efficiency than SQUASHFS, this is mainly due to Nilsimsa ordering, 

<img width="424" height="321" alt="image" src="https://github.com/user-attachments/assets/5f2f909b-c896-4b6f-bd7a-409c64de5d06" />

* Running `mkdwarfs` with `--order=path` which removes Nilsimsa ordering improves the efficiency a lot **(from 18% to 68%)**. But still lower than the 95% of SQUASHFS. **I have no idea what is responsible of the 27% difference.** `--no-section-index` and `--window-size=0` had no impact in the zsync efficiency.

<img width="447" height="307" alt="image" src="https://github.com/user-attachments/assets/d7192785-befb-4fd3-a39e-795df4db4cd3" />

* Block size and compression level doesn't really change the zsync efficiency.

* `--order=none` is worse than `--order=path`, efficiency is 34%.

<img width="430" height="215" alt="image" src="https://github.com/user-attachments/assets/1392a065-da65-47db-b447-f2b4b5c4126c" />


# TLDR: Use `mkdwarfs` with `--order=path` to have good zsync efficiency, compression level, block size and other options don't seem to help at all.

---

* Bonus: `zstd10` with `-S20` (1MIB blocks) doesn't really increase the launch speed. You are better off always using `zstd22` and `-S26` (64 MIB blocks).

<img width="556" height="219" alt="image" src="https://github.com/user-attachments/assets/c7abe7f1-d970-4752-9daf-6ae7b7ebfe28" />
