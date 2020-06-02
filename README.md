# RDH-for-JPEG-images
Several state-of-the-arts RDH schemes for JPEG images.

为了方便介绍，对于JPEG无损信息隐藏，在本文，使用RHD-J表示。

Warning:
- 因为基于DCT系数修改的RDH-J方法有几个函数使用重复，因此把这些函数都单独放在了util文件夹下，统一调用，减少冗余。
- 基于DCT系数修改的RDH-J方法只实现了嵌入，并未实现提取。

## References

### DCT-based schemes

| Title 	| Links 	|
|-	|-	|
| Reversible data hiding in JPEG images 	| https://ieeexplore.ieee.org/abstract/document/7225117/authors#authors 	|
| Reversible Data Hiding in JPEG Images Using Ordered Embedding 	| http://www.itiis.org/digital-library/manuscript/1608 	|
| Improved reversible data hiding in JPEG images based on new coefficient selection strategy 	| https://link.springer.com/article/10.1186/s13640-017-0206-1 	|
| Reversible data hiding in JPEG image based on DCT frequency and block selection 	| https://www.sciencedirect.com/science/article/pii/S0165168418300483 	|
| Reversible Data Hiding in JPEG Images Based on Negative Influence Models 	| https://ieeexplore.ieee.org/document/8930621 	|
| Reversible data hiding for JPEG images based on pairwise nonzero AC coefficient expansion 	| https://www.sciencedirect.com/science/article/abs/pii/S0165168419304785 	|
| Reversible Data Hiding in JPEG Images with Multi-objective Optimization 	| https://ieeexplore.ieee.org/document/8970412 	|

