Rosetta入门
====================

..   :numbered:
.. :caption: 目录
..   :maxdepth: 1

.. raw:: html
   :file: frontpage.html

.. toctree::

   README_CN
   getting-started
   examples/index

.. raw:: html
   <h2 class="toc"> Document Instllation </h2>

.. code-block::

   sudo apt-get install git make
   sudo apt-get install python3 python3-pip jupyter
   sudo pip3 install Sphinx
   sudo pip3 install sphinx-autobuild sphinx_rtd_theme sphinx_materialdesign_theme mxtheme
   sudo pip3 install recommonmark sphinx_markdown_tables
   sudo pip3 install jieba nbsphinx ipython
   sudo pip3 install pandas md2ipynb notedown
   sudo pip3 install beautifulsoup4 awscli
   sudo pip3 install notebook matplotlib

.. raw:: html
   <h2 class="toc"> Usage </h2>

.. code-block::

   sudo make clean
   sudo make
   sudo sphinx-autobuild build build/_build/html
   sudo sphinx-build -b html -d _build/doctrees   ._build/html
