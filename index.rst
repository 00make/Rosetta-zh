Rosetta入门
====================

..   :numbered:

.. raw:: html
   :file: frontpage.html

.. toctree::
   :caption: 目录
   :maxdepth: 2


   chapter_preface/preface
   getting-started
   examples/index



sudo apt-get install git make
sudo apt-get install python3 python3-pip jupyter
sudo pip3 install Sphinx
sudo pip3 install sphinx-autobuild sphinx_rtd_theme sphinx_materialdesign_theme mxtheme
sudo pip3 install recommonmark sphinx_markdown_tables
sudo pip3 install jieba nbsphinx ipython
sudo pip3 install pandas md2ipynb notedown
sudo pip3 install beautifulsoup4 awscli
sudo pip3 install notebook matplotlib

.. sudo pip3 install mxnet-cu100

sudo make clean
sudo make
sudo sphinx-autobuild build build/_build/html

sphinx-build -b html -d _build/doctrees   ._build/html
