<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN"
  "http://www.w3.org/TR/html4/strict.dtd">
<html lang=ja>
<head>
<meta http-equiv="Content-Type" content="text/html; CHARSET=euc-jp">
<meta http-equiv="Content-Script-Type" content="text/javascript; CHARSET=euc-jp">
<meta http-equiv="Content-Style-Type" content="text/css; CHARSET=euc-jp">
<link rel="stylesheet" href="http://kodama.fubuki.info/wiki/./style/old-pavement_kodama/old-pavement_kodama.css" type="text/css">
<meta name="Author" content="Chihiro Kodama">
<title>xcbar.gs</title>
<script type="text/javascript">
<!--
function common_init()
{


    // move focus
    var elm = document.getElementById( 'wiki-text' );
    if( ! elm ){ return 1; }
    elm.focus();
    //
    var pos = 0;
    var elm_focus = document.getElementById( 'wiki-text-focus' );
    if( elm_focus ){ pos = elm_focus.value; }
    //
    var pos2 = pos;
    var elm_focus2 = document.getElementById( 'wiki-text-focus2' );
    if( elm_focus ){ pos2 = elm_focus2.value; }
    //
    // multi-browser support
    if ( elm.setSelectionRange )
    {
        elm.setSelectionRange( pos, pos2 );
    }
    else if ( elm.createTextRange )
    {
        alert("focus not supported!");
        var range = elm.createTextRange();
        range.move( 'character', pos );
        range.select();
    }
}
function changeExpand(ch)
{
    var obj = document.getElementById(ch).style;
    if( obj.display == "none" ){ obj.display = "inline"; }
    else                       { obj.display = "none"; }
//    alert( obj.display );
}
function showExpand(ch)
{
    document.getElementById(ch).style.display = "inline";
}
function noshowExpand(ch)
{
    document.getElementById(ch).style.display = "none";
}
function allShowExpand()
{

}
-->
</script>
</head>

<body onload="common_init()">
<div class="main">
<div class="adminmenu">
<span class="adminmenu"><a href="http://kodama.fubuki.info/wiki/wiki.cgi/GrADS/script/xcbar%2egs?sw=show_login&amp;lang=jp">ログイン</a></span>
</div> <!-- end of adminmenu -->
<h1>xcbar.gs</h1>
<div class="day">
<div class="body">
<div class="section">

<div>
<a href="http://kodama.fubuki.info/wiki/wiki.cgi?lang=jp">Top</a> / <a href="http://kodama.fubuki.info/wiki/wiki.cgi/GrADS?lang=jp">GrADS</a> / <a href="http://kodama.fubuki.info/wiki/wiki.cgi/GrADS/script?lang=jp">script</a> / <a href="http://kodama.fubuki.info/wiki/wiki.cgi/GrADS/script/xcbar%2egs?lang=jp">xcbar.gs</a></div>


<p>
<a href="http://kodama.fubuki.info/wiki/wiki.cgi/GrADS/script/xcbar%2egs?lang=jp"><img src="http://kodama.fubuki.info/wiki/wiki.cgi/MainHeader?sw=download&amp;file=japanese_thumb.png" alt="Japanese"></a> / <a href="http://kodama.fubuki.info/wiki/wiki.cgi/GrADS/script/xcbar%2egs?lang=en"><img src="http://kodama.fubuki.info/wiki/wiki.cgi/MainHeader?sw=download&amp;file=english_thumb.png" alt="English"></a>
</p>

<ul>
<li><a href="#0">名前</a></li>
<li><a href="#1">概要</a></li>
<li><a href="#2">説明</a></li>
<li><a href="#3">引数</a></li>
<li><a href="#4">使用例</a></li>
<li><a href="#11">ソースコード</a></li>
</ul>

<h2><a name="0"> </a>名前</h2>
<div class="h2below">
<div class="h2belowright">
</div> <!-- end of h2belowright -->
</div> <!-- end of h2below -->
<div id="h_0">
<p>
<strong>xcbar</strong> - カラーバーを任意の位置・大きさで描画する。
</p>

</div> <!-- end of h_0 -->
<h2><a name="1"> </a>概要</h2>
<div class="h2below">
<div class="h2belowright">
</div> <!-- end of h2belowright -->
</div> <!-- end of h2below -->
<div id="h_1">
<pre>
<strong>xcbar</strong>
    [ <span style="font-style: italic;">xmin</span> <span style="font-style: italic;">xmax</span> <span style="font-style: italic;">ymin</span> <span style="font-style: italic;">ymax</span> ]
    [ ( -xoffset | -xo ) <span style="font-style: italic;">xoffset</span> ] [ ( -yoffset | -yo ) <span style="font-style: italic;">yoffset</span> ]
    [ ( -fwidth | -fw ) <span style="font-style: italic;">fwidth</span> ]
    [ ( -fheight | -fh ) <span style="font-style: italic;">fheight</span> ]
    [ ( -fthickness | -ft ) <span style="font-style: italic;">fthickness</span> ]
    [ ( -fskip | -fstep | -fs ) <span style="font-style: italic;">fskip</span> ]
    [ ( -foffset | -fo ) ( <span style="font-style: italic;">foffset</span> | center ) ]
    [ ( -fcolor | -fc ) <span style="font-style: italic;">fcolor</span> ]
    [ ( -fxoffset | -fx ) <span style="font-style: italic;">fxoffset</span> ] [ ( -fyoffset | -fy ) <span style="font-style: italic;">fyoffset</span> ]
    [ -edge ( box | triangle | circle ) ]
    [ ( -direction | -d ) ( horizontal | h | vertical | v ) ]
    [ -line [ on | off] ]
    [ ( -linecolor | -lc ) <span style="font-style: italic;">linecolor</span> ]
    [ -levcol c(1) l(1) c(2) level(2) ... l(cnum-1) c(cnum) ]
</pre>

</div> <!-- end of h_1 -->
<h2><a name="2"> </a>説明</h2>
<div class="h2below">
<div class="h2belowright">
</div> <!-- end of h2belowright -->
</div> <!-- end of h2below -->
<div id="h_2">
<p>
<span style="font-style: italic;">xmin</span>, <span style="font-style: italic;">xmax</span>, <span style="font-style: italic;">ymin</span>, <span style="font-style: italic;">ymax</span> の指定がない場合は、cbar.gs のように自動的に位置が決まる。
引数なしで実行するとヘルプが表示される。
</p>

</div> <!-- end of h_2 -->
<h2><a name="3"> </a>引数</h2>
<div class="h2below">
<div class="h2belowright">
</div> <!-- end of h2belowright -->
</div> <!-- end of h2below -->
<div id="h_3">
<dl>
  <dt><span style="font-style: italic;">xmin</span>                            </dt>
  <dd>カラーバーの左側のX座標値</dd>
</dl>
<dl>
  <dt><span style="font-style: italic;">xmax</span>                            </dt>
  <dd>カラーバーの右側のX座標値</dd>
</dl>
<dl>
  <dt><span style="font-style: italic;">ymin</span>                            </dt>
  <dd>カラーバーの下側のY座標値</dd>
</dl>
<dl>
  <dt><span style="font-style: italic;">ymax</span>                            </dt>
  <dd>カラーバーの上側のY座標値</dd>
</dl>
<dl>
  <dt>( -xoffset | -xo ) <span style="font-style: italic;">xoffset</span> ]    </dt>
  <dd>カラーバーの位置の標準からのX方向のずれ。デフォルト値は 0。</dd>
</dl>
<dl>
  <dt>( -yoffset | -yo ) <span style="font-style: italic;">yoffset</span> ]    </dt>
  <dd>カラーバーの位置の標準からのY方向のずれ。デフォルト値は 0。</dd>
</dl>
<dl>
  <dt>( -fwidth | -fw ) <span style="font-style: italic;">fwidth</span>        </dt>
  <dd>フォントの幅。デフォルト値は 0.12。</dd>
</dl>
<dl>
  <dt>( -fheight | -fh ) <span style="font-style: italic;">fheight</span>      </dt>
  <dd>フォントの高さ。デフォルト値は 0.13。</dd>
</dl>
<dl>
  <dt>( -fthickness | -ft ) <span style="font-style: italic;">fthickness</span></dt>
  <dd>フォントの太さ。デフォルト値は <span style="font-style: italic;">height</span>×40。</dd>
</dl>
<dl>
  <dt>( -fskip | -fstep | -fs ) <span style="font-style: italic;">fstep</span> </dt>
  <dd>ラベルのステップ(間隔)。デフォルト値は 1。</dd>
</dl>
<dl>
  <dt>( -foffset | -fo ) ( <span style="font-style: italic;">foffset</span> | center )</dt>
  <dd>ラベルの開始位置(最小値のラベルが0)。centerを指定するとラベルをできるだけ中央に配置する。デフォルト値は <span style="font-style: italic;">offset</span>=0。</dd>
</dl>
<dl>
  <dt>( -fcolor | -fc ) <span style="font-style: italic;">fcolor</span>        </dt>
  <dd>ラベルの色。デフォルト値は 1。</dd>
</dl>
<dl>
  <dt>( -fxoffset | -fx ) <span style="font-style: italic;">fxoffset</span> ]  </dt>
  <dd>ラベル位置の標準からのX方向のずれ。デフォルト値は 0。</dd>
</dl>
<dl>
  <dt>( -fyoffset | -fy ) <span style="font-style: italic;">fyoffset</span> ]  </dt>
  <dd>ラベル位置の標準からのY方向のずれ。デフォルト値は 0。</dd>
</dl>
<dl>
  <dt>-edge ( box | triangle | circle )   </dt>
  <dd>ラベル端の形。デフォルト値は "box".</dd>
</dl>
<dl>
  <dt>( -direction | -d ) ( horizontal | h | vertical | v )</dt>
  <dd>カラーバーの向き(水平: horizontal 又は h、鉛直: vertical 又は v)。デフォルト値は "horizontal"。</dd>
</dl>
<dl>
  <dt>-line [ on | off]                   </dt>
  <dd>カラーバーの境界線の有無。デフォルトは "off"。-line を指定するとデフォルトで "on"。</dd>
</dl>
<dl>
  <dt>( -linecolor | -lc ) <span style="font-style: italic;">linecolor</span>  </dt>
  <dd>カラーバーの境界線の色。デフォルト値は 1。</dd>
</dl>
<dl>
  <dt>-levcol c(1) l(1) c(2) level(2) ... l(cnum-1) c(cnum)</dt>
  <dd>カラー番号とレベル。これを使うと、図を描く前にカラーバーを描くことができる。</dd>
</dl>

</div> <!-- end of h_3 -->
<h2><a name="4"> </a>使用例</h2>
<div class="h2below">
<div class="h2belowright">
</div> <!-- end of h2belowright -->
</div> <!-- end of h2below -->
<div id="h_4">

<h4><a name="5"> </a>(1) 1.5&lt;=x&lt;=9.5, 0.5&lt;=y&lt;=0.7 にカラーバーを描く。</h4>
<div id="h_5">
<pre>
ga-&gt; open t.ctl
ga-&gt; set gxout shaded
ga-&gt; d t
ga-&gt; xcbar 1.5 9.5 0.5 0.7
</pre>
<img src="http://kodama.fubuki.info/wiki/./attach/GrADS/script/xcbar%252egs.wiki/xcbar%255fsample1.png">

</div> <!-- end of h_5 -->
<h4><a name="6"> </a>(2) 9.5&lt;=x&lt;=9.7, 1.5&lt;=y&lt;=7.0 に縦長のカラーバーを描く。</h4>
<div id="h_6">
<pre>
ga-&gt; open ps.ctl
ga-&gt; set lat 20 60
ga-&gt; set lon 120 160
ga-&gt; set gxout shaded
ga-&gt; d ps
ga-&gt; xcbar 9.5 9.7 1.5 7.0
</pre>
<img src="http://kodama.fubuki.info/wiki/./attach/GrADS/script/xcbar%252egs.wiki/xcbar%255fsample2.png">
<ul>
  <li>
    位置に応じて縦長・横長は自動的に決まるため、ふつうは-directionを指定する必要はありません。
  </li>
</ul>

</div> <!-- end of h_6 -->
<h4><a name="7"> </a>(3) 色と色の間および外周に線を描き、丸端のカラーバーを描く。</h4>
<div id="h_7">
<pre>
ga-&gt; open u.ctl
ga-&gt; set gxout shaded
ga-&gt; set lev 500
ga-&gt; d u
ga-&gt; xcbar -line on -edge circle
</pre>
<img src="http://kodama.fubuki.info/wiki/./attach/GrADS/script/xcbar%252egs.wiki/xcbar%255fsample3.png">
<ul>
  <li>
    位置を指定しない場合、cbar.gsのように自動的に位置が決まります。
  </li>
</ul>

</div> <!-- end of h_7 -->
<h4><a name="8"> </a>(4) 1&lt;=x&lt;=10, 0.7&lt;=y&lt;=0.9 に、ラベルの幅(0.15)と高さ(0.18)を指定して三角端のカラーバーを描く。</h4>
<div id="h_8">
<pre>
ga-&gt; open t.ctl
ga-&gt; set gxout shaded
ga-&gt; set z 3
ga-&gt; d t-273.15
ga-&gt; xcbar 1 10 0.7 0.9 -fw 0.15 -fh 0.18 -edge triangle
</pre>
<img src="http://kodama.fubuki.info/wiki/./attach/GrADS/script/xcbar%252egs.wiki/xcbar%255fsample4.png">

</div> <!-- end of h_8 -->
<h4><a name="9"> </a>(5) 上と同じ条件に加えて、ラベルの出力間隔を2として開始位置を1ずらす。</h4>
<div id="h_9">
<pre>
ga-&gt; open t.ctl
ga-&gt; set gxout shaded
ga-&gt; set z 3
ga-&gt; d t-273.15
ga-&gt; xcbar 1 10 0.7 0.9 -fw 0.15 -fh 0.18 -edge triangle -fs 2 -fo 1
</pre>
<img src="http://kodama.fubuki.info/wiki/./attach/GrADS/script/xcbar%252egs.wiki/xcbar%255fsample5.png">

</div> <!-- end of h_9 -->
<h4><a name="10"> </a>(6) 図を描くことなくカラーバーを描く。</h4>
<div id="h_10">
<pre>
ga-&gt; xcbar 2 9 0.3 0.5 -levcol 1 -50 2 -40 3 -30 4 -20 5 -10 6 0 7 -line on
</pre>
<img src="http://kodama.fubuki.info/wiki/./attach/GrADS/script/xcbar%252egs.wiki/xcbar%255fsample6.png">

</div> <!-- end of h_10 -->
</div> <!-- end of h_4 -->
<h2><a name="11"> </a>ソースコード</h2>
<div class="h2below">
<div class="h2belowright">
</div> <!-- end of h2belowright -->
</div> <!-- end of h2below -->
<div id="h_11">
<ul>
  <li>
    <a href="https://github.com/kodamail/gscript/blob/master/xcbar.gs">xcbar.gs</a> (必須)
  </li>
</ul>

<script type="text/javascript">
<!--
document.write("<img src='http://kodamail.sakura.ne.jp/acc/fubuki/acclog.cgi?");
document.write("referrer="+document.referrer+"&");
document.write("width="+screen.width+"&");
document.write("height="+screen.height+"&");
document.write("color="+screen.colorDepth+"'>");
-->
</script>
</div> <!-- end of h_11 -->
</div> <!-- end of section -->
</div> <!-- end of body -->
</div> <!-- end of day -->
</div> <!-- end of main -->
<div class="sidebar">

<h3><a name="12"> </a>私自身について</h3>
<div id="h_12">
<ul>
  <li>
    <a href="http://kodama.fubuki.info/wiki/wiki.cgi/self%5fintroduction?lang=jp">自己紹介</a>
  </li>
  <li>
    <a href="http://kodama.fubuki.info/wiki/wiki.cgi/research?lang=jp">研究活動</a>
  </li>
  <li>
    <a href="http://kodama.fubuki.info/wiki/wiki.cgi/keywords?lang=jp">キーワード</a>
  </li>
</ul>
</div> <!-- end of h_12 -->
<h3><a name="13"> </a>GrADS</h3>
<div id="h_13">
<ul>
  <li>
    <a href="http://kodama.fubuki.info/wiki/wiki.cgi/GrADS/install?lang=jp">インストール</a>
  </li>
  <li>
    <a href="http://kodama.fubuki.info/wiki/wiki.cgi/GrADS/tips%5fcommand?lang=jp">GrADSのTips</a>
  </li>
  <li>
    <a href="http://kodama.fubuki.info/wiki/wiki.cgi/GrADS/tips%5fscript?lang=jp">GrADSスクリプトのTips</a>
  </li>
  <li>
    <a href="http://kodama.fubuki.info/wiki/wiki.cgi/GrADS/script?lang=jp">スクリプト集</a>
  </li>
</ul>
</div> <!-- end of h_13 -->
<h3><a name="14"> </a>Tools</h3>
<div id="h_14">
<ul>
  <li>
    <a href="http://kodama.fubuki.info/wiki/wiki.cgi/tool/imgtree?lang=jp">imgtree</a>
  </li>
  <li>
    <a href="http://kodama.fubuki.info/wiki/wiki.cgi/tool/data%5fconv?lang=jp">data_conv</a>
  </li>
</ul>
</div> <!-- end of h_14 -->
<h3><a name="15"> </a>プログラミング</h3>
<div id="h_15">
<ul>
  <li>
    <a href="http://kodama.fubuki.info/wiki/wiki.cgi/Fortran?lang=jp">FortranのTips</a>
  </li>
  <li>
    <a href="http://kodama.fubuki.info/wiki/wiki.cgi/bash/tips?lang=jp">BashのTips</a>
  </li>
  <li>
    <a href="http://kodama.fubuki.info/wiki/wiki.cgi/Git?lang=jp">GitのTips</a>
  </li>
</ul>
</div> <!-- end of h_15 -->
<h3><a name="16"> </a>その他</h3>
<div id="h_16">
<ul>
  <li>
    <a href="http://kodama.fubuki.info/wiki/wiki.cgi/emacs?lang=jp">emacs</a>
  </li>
  <li>
    <a href="http://kodama.fubuki.info/wiki/wiki.cgi/linux%5ftrash?lang=jp">linuxゴミ箱</a>
  </li>
  <li>
    <a href="http://kodama.fubuki.info/wiki/wiki.cgi/old?lang=jp">古いページ</a>
  </li>
</ul>
</div> <!-- end of h_16 -->
<h3><a name="17"> </a>更新履歴</h3>
<div id="h_17">
<p>
</p><p class=recentitem>2016/02/19</p><p>
<ul class=recentsubtitles><li class=recentsubtitles><div class=recentsubtitles><a href="http://kodama.fubuki.info/wiki/wiki.cgi/research?lang=jp">研究活動</a></div></li></ul>
</p><p class=recentitem>2016/02/11</p><p>
<ul class=recentsubtitles><li class=recentsubtitles><div class=recentsubtitles><a href="http://kodama.fubuki.info/wiki/wiki.cgi/bash/tips?lang=jp">BashのTips</a></div></li></ul>
</p><p class=recentitem>2015/12/18</p><p>
<ul class=recentsubtitles><li class=recentsubtitles><div class=recentsubtitles><a href="http://kodama.fubuki.info/wiki/wiki.cgi/self%5fintroduction?lang=jp">自己紹介</a></div></li></ul>
</p><p class=recentitem>2015/12/17</p><p>
<ul class=recentsubtitles><li class=recentsubtitles><div class=recentsubtitles><a href="http://kodama.fubuki.info/wiki/wiki.cgi/GrADS/script/history?lang=jp">更新履歴</a></div></li></ul>
</p><p class=recentitem>2015/11/28</p><p>
<ul class=recentsubtitles><li class=recentsubtitles><div class=recentsubtitles><a href="http://kodama.fubuki.info/wiki/wiki.cgi/GrADS/script?lang=jp">スクリプト集</a></div></li></ul>
</p><p class=recentitem>2015/11/25</p><p>
<ul class=recentsubtitles><li class=recentsubtitles><div class=recentsubtitles><a href="http://kodama.fubuki.info/wiki/wiki.cgi/Fortran?lang=jp">FortranのTips</a></div></li></ul>
</p><p class=recentitem>2015/11/22</p><p>
<ul class=recentsubtitles><li class=recentsubtitles><div class=recentsubtitles><a href="http://kodama.fubuki.info/wiki/wiki.cgi/Default?lang=jp">小玉知央の家頁</a></div></li></ul>
<ul class=recentsubtitles><li class=recentsubtitles><div class=recentsubtitles><a href="http://kodama.fubuki.info/wiki/wiki.cgi/GrADS/script/ico%2egs?lang=jp">ico.gs</a></div></li></ul>
<ul class=recentsubtitles><li class=recentsubtitles><div class=recentsubtitles><a href="http://kodama.fubuki.info/wiki/wiki.cgi/GrADS/script/xmath%5fmin%2egsf?lang=jp">xmath_min.gsf</a></div></li></ul>
<ul class=recentsubtitles><li class=recentsubtitles><div class=recentsubtitles><a href="http://kodama.fubuki.info/wiki/wiki.cgi/GrADS/script/xmath%5fmax%2egsf?lang=jp">xmath_max.gsf</a></div></li></ul>
<ul class=recentsubtitles><li class=recentsubtitles><div class=recentsubtitles><a href="http://kodama.fubuki.info/wiki/wiki.cgi/GrADS/script/v2s%2egsf?lang=jp">v2s.gsf</a></div></li></ul>
<ul class=recentsubtitles><li class=recentsubtitles><div class=recentsubtitles><a href="http://kodama.fubuki.info/wiki/wiki.cgi/GrADS/script/tsteps%2egsf?lang=jp">tsteps.gsf</a></div></li></ul>
<ul class=recentsubtitles><li class=recentsubtitles><div class=recentsubtitles><a href="http://kodama.fubuki.info/wiki/wiki.cgi/GrADS/script/time2t%2egsf?lang=jp">time2t.gsf</a></div></li></ul>
<ul class=recentsubtitles><li class=recentsubtitles><div class=recentsubtitles><a href="http://kodama.fubuki.info/wiki/wiki.cgi/GrADS/script/t2time%2egsf?lang=jp">t2time.gsf</a></div></li></ul>
<ul class=recentsubtitles><li class=recentsubtitles><div class=recentsubtitles><a href="http://kodama.fubuki.info/wiki/wiki.cgi/GrADS/script/sublw%2egsf?lang=jp">sublw.gsf</a></div></li></ul>
<ul class=recentsubtitles><li class=recentsubtitles><div class=recentsubtitles><a href="http://kodama.fubuki.info/wiki/wiki.cgi/GrADS/script/strtrim%2egsf?lang=jp">strtrim.gsf</a></div></li></ul>
<ul class=recentsubtitles><li class=recentsubtitles><div class=recentsubtitles><a href="http://kodama.fubuki.info/wiki/wiki.cgi/GrADS/script/strrep%2egsf?lang=jp">strrep.gsf</a></div></li></ul>
<ul class=recentsubtitles><li class=recentsubtitles><div class=recentsubtitles><a href="http://kodama.fubuki.info/wiki/wiki.cgi/GrADS/script/qxy2gr%2egsf?lang=jp">qxy2gr.gsf</a></div></li></ul>
<ul class=recentsubtitles><li class=recentsubtitles><div class=recentsubtitles><a href="http://kodama.fubuki.info/wiki/wiki.cgi/GrADS/script/qgr2xy%2egsf?lang=jp">qgr2xy.gsf</a></div></li></ul>
<ul class=recentsubtitles><li class=recentsubtitles><div class=recentsubtitles><a href="http://kodama.fubuki.info/wiki/wiki.cgi/GrADS/script/qgr2w%2egsf?lang=jp">qgr2w.gsf</a></div></li></ul>
</p>

</div> <!-- end of h_17 -->
</div> <!-- end of sidebar -->
<div class="footer">
Copyright &copy; 2006-2015 Chihiro Kodama<br>
Powered by myfastwiki ver0.36 r1 ( released 2015/09/30 )<br>
</div> 
<!-- end of footer -->
</body>
</html>
