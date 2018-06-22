<body>




<h1 class="title toc-ignore">Calulating growth z-scores</h1>
<h4 class="author"><em>Aaron D. Blackwell</em></h4>
<h4 class="date"><em>2018-06-21</em></h4>



<p>The <strong>localgrowth</strong> package provides functions to calculate z-scores and centile values for measurements of height, weight, and BMI based on both widely used growth standards and references (CDC, WHO) and references from other populations. The included LMS files are for calculating height-for-age, weight-for-age, BMI-for-age, and weight-for-height z-scores.</p>
<p>The primary function for <strong>localgrowth</strong> is <code>growthRef</code>, which provides an interface for calcualting z-scores or centiles from one or more growth references. Other functions include <code>centilesLMS</code> which generates centile tables for reference or plotting, and <code>ZfromLMS</code> which does simple calculations from LMS values.</p>
<div id="installing-localgrowth-and-reporting-bugs" class="section level2">
<h2>Installing localgrowth and reporting bugs</h2>
<p><strong>localgrowth</strong> can be installed directly from github. If <strong>devtools</strong> is already installed the first line can be skipped:</p>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r"><span class="kw">install.packages</span>(<span class="st">'devtools'</span>)
devtools<span class="op">::</span><span class="kw">install_github</span>(<span class="st">'adblackwell/localgrowth'</span>,<span class="dt">build_vignettes =</span> <span class="ot">TRUE</span>)</code></pre></div>
<p>Bug reports can also be filed on github, at <a href="https://github.com/adblackwell/localgrowth/issues" class="uri">https://github.com/adblackwell/localgrowth/issues</a>.</p>
</div>
<div id="included-growth-standards-and-references" class="section level2">
<h2>Included growth standards and references</h2>
<p>Four sets of references/standards are currently including in <strong>localgrowth</strong>. These include references for the Tsimane and Shuar indigenous groups of Bolivia and Ecuador, which were developed as population specific references, but may be useful for other South American populations. See the papers under the <a href="#references">References</a> section for further details on the development and use of these references.</p>
</div>
<div id="using-growthref-to-calculate-z-scores" class="section level2">
<h2>Using ‘growthRef’ to calculate z-scores</h2>
<p>The included data set <code>TsimaneData</code> includes 200 measurements of height, weight, and BMI, taken from the Tsimane growth data set in Blackwell, et al (2017). further documentation can be found with <code>?TsimaneData</code>. We will use this data for examples:</p>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r"><span class="kw">library</span>(localgrowth)
<span class="kw">data</span>(TsimaneData)
<span class="kw">head</span>(TsimaneData)
<span class="co">#&gt;       PID    Sex        Age Height Weight      BMI</span>
<span class="co">#&gt; 1 TGD3465   Male  8.0219028  122.8   26.4 17.50682</span>
<span class="co">#&gt; 2 TGD1433 Female 15.1869724  150.0   60.1 26.71111</span>
<span class="co">#&gt; 3 TGD7135 Female  2.3053840   84.0   11.7 16.58163</span>
<span class="co">#&gt; 4 TGD0304   Male  0.5778006   68.0    7.4 16.00346</span>
<span class="co">#&gt; 5 TGD6486 Female 16.6133927  164.4   77.4 28.63765</span>
<span class="co">#&gt; 6 TGD3227 Female 10.8118868  134.0   31.9 17.76565</span></code></pre></div>
<p>To calculate z-scores based on all four references, for height-for-age:</p>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r">HFA&lt;-<span class="kw">growthRef</span>(Age,Height,Sex,<span class="dt">data=</span>TsimaneData,<span class="dt">type=</span><span class="st">&quot;Height&quot;</span>)
<span class="kw">head</span>(HFA)
<span class="co">#&gt;   Z.CDC.Height Z.WHO.Height Z.Tsimane.Height Z.Shuar.Height</span>
<span class="co">#&gt; 1   -0.9119514   -0.8102912      0.968145840      1.2686779</span>
<span class="co">#&gt; 2   -1.8618328   -1.7323427      0.001605685      0.5694053</span>
<span class="co">#&gt; 3   -1.1298073   -1.4140430      0.472562277      0.2313592</span>
<span class="co">#&gt; 4   -0.2162897   -0.4914509      0.297327698      0.3471471</span>
<span class="co">#&gt; 5    0.2477139    0.2450246      3.105175105      3.2166799</span>
<span class="co">#&gt; 6   -1.2310664   -1.4820008      0.105049843      0.4281562</span></code></pre></div>
<p>Similarly for weight-for-height:</p>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r">WFH&lt;-<span class="kw">growthRef</span>(Height,Weight,Sex,<span class="dt">data=</span>TsimaneData,<span class="dt">type=</span><span class="st">&quot;WFH&quot;</span>)
<span class="kw">head</span>(WFH)
<span class="co">#&gt;     Z.CDC.WFH  Z.WHO.WFH Z.Tsimane.WFH Z.Shuar.WFH</span>
<span class="co">#&gt; 1          NA         NA     0.8281672          NA</span>
<span class="co">#&gt; 2          NA         NA     1.7066106          NA</span>
<span class="co">#&gt; 3  0.06541016  0.5398625     0.2554352          NA</span>
<span class="co">#&gt; 4 -0.90851972 -0.9112184    -0.4794951          NA</span>
<span class="co">#&gt; 5          NA         NA            NA          NA</span>
<span class="co">#&gt; 6          NA         NA     0.3032575          NA</span></code></pre></div>
<p>Note that weight-for-height can only be calculated for selected ranges of heights, and is not available for the Shuar references at all. When a value is out of range of the reference, a <code>NA</code> is returned.</p>
<p>We can also request just values based on CDC and Tsimane references, and format output as centiles instead of z-scores:</p>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r">HFA&lt;-<span class="kw">growthRef</span>(Age,Height,Sex,<span class="dt">data=</span>TsimaneData,<span class="dt">type=</span><span class="st">&quot;Height&quot;</span>,<span class="dt">pop=</span><span class="kw">c</span>(<span class="st">&quot;CDC&quot;</span>,<span class="st">&quot;Tsimane&quot;</span>),<span class="dt">z=</span><span class="st">&quot;centile&quot;</span>)
<span class="kw">head</span>(HFA)
<span class="co">#&gt;   Z.CDC.Height Z.Tsimane.Height</span>
<span class="co">#&gt; 1   -0.9119514      0.968145840</span>
<span class="co">#&gt; 2   -1.8618328      0.001605685</span>
<span class="co">#&gt; 3   -1.1298073      0.472562277</span>
<span class="co">#&gt; 4   -0.2162897      0.297327698</span>
<span class="co">#&gt; 5    0.2477139      3.105175105</span>
<span class="co">#&gt; 6   -1.2310664      0.105049843</span></code></pre></div>
<p>When only a single type of score is requested, a vector rather than a data frame is returned:</p>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r">BFA&lt;-<span class="kw">growthRef</span>(Age,BMI,Sex,<span class="dt">data=</span>TsimaneData,<span class="dt">type=</span><span class="st">&quot;BMI&quot;</span>,<span class="dt">pop=</span><span class="st">&quot;CDC&quot;</span>)
<span class="kw">head</span>(BFA)
<span class="co">#&gt; [1] 0.8695613 1.4507304 0.2943497        NA 1.5671976 0.1711645</span></code></pre></div>
</div>
<div id="referencing-lms-tables-directly" class="section level2">
<h2>Referencing LMS tables directly</h2>
<p>Typically, <code>growthRef</code> will be used with the <code>type</code> and <code>pop</code> arguements which allow for multiple references to be returned simultaneously. However, sometimes it may be useful to call an LMS table directly. LMS tables internal to <strong>localgrowth</strong> are named after the population and type, i.e. <code>CDC.WFH</code> or <code>Tsimane.Weight</code>. These can be called by name with the <code>LMS</code> arguement. Note that other, non-internal LMS tables can also be used, provided they are in the right format.</p>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r">WFH&lt;-<span class="kw">growthRef</span>(Height,Weight,Sex,<span class="dt">data=</span>TsimaneData,<span class="dt">LMS=</span>CDC.WFH,<span class="dt">z=</span><span class="st">&quot;centile&quot;</span>)
<span class="kw">head</span>(WFH)
<span class="co">#&gt; [1]          NA          NA  0.06541016 -0.90851972          NA          NA</span></code></pre></div>
<div id="the-getz-function" class="section level3">
<h3>The <code>getZ</code> function</h3>
<p>‘growthRef’ works by organizing the input and calling he function <code>getZ</code> to calculate Z-scores. <code>getZ</code> can also be called directly with an LMS table specified, as can ‘getCentile’:</p>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r"><span class="co">#Tsimane specific z-score for a single individual, age 2 yrs, 75 cm, male.</span>
<span class="kw">getZ</span>(<span class="dv">2</span>,<span class="dv">75</span>,<span class="st">&quot;Male&quot;</span>,Tsimane.Height)
<span class="co">#&gt; [1] -1.100132</span>
<span class="kw">getCentile</span>(<span class="dv">2</span>,<span class="dv">75</span>,<span class="st">&quot;Male&quot;</span>,Tsimane.Height)
<span class="co">#&gt; [1] 0.1356373</span></code></pre></div>
</div>
</div>
<div id="showing-reference-values" class="section level2">
<h2>Showing reference values</h2>
<p>The function ‘centilesLMS’ allows for the production of custom centile tables from either internal or external LMS files. This can be useful for producing comparisons for plots. For example, we might want to show how a particular individuals growth compares to Tsimane standards:</p>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r"><span class="co">#Subset the observations for one individual </span>
ind&lt;-TsimaneData[TsimaneData<span class="op">$</span>PID<span class="op">==</span><span class="st">'TGD0734'</span>,]
<span class="co">#Get the 2.5, 50, and 97.5 centiles for age 2 to 7, for plotting</span>
cent&lt;-<span class="kw">centilesLMS</span>(<span class="kw">seq</span>(<span class="dv">2</span>,<span class="dv">7</span>,<span class="fl">0.1</span>),<span class="st">&quot;Female&quot;</span>,Tsimane.Height,<span class="dt">cent=</span><span class="kw">c</span>(<span class="fl">0.025</span>,<span class="fl">0.5</span>,<span class="fl">0.975</span>),<span class="dt">xname=</span><span class="st">&quot;Age&quot;</span>)
<span class="kw">plot</span>(Height<span class="op">~</span>Age,<span class="dt">data=</span>ind,<span class="dt">ylim=</span><span class="kw">range</span>(cent[,<span class="dv">2</span><span class="op">:</span><span class="dv">4</span>]),<span class="dt">xlim=</span><span class="kw">c</span>(<span class="dv">2</span>,<span class="dv">7</span>),<span class="dt">pch=</span><span class="dv">19</span>,<span class="dt">main=</span><span class="st">&quot;Height growth for TGD0734&quot;</span>)
<span class="kw">lines</span>(cent<span class="op">$</span>Age,cent<span class="op">$</span><span class="st">'0.5'</span>,<span class="dt">col=</span><span class="st">&quot;red&quot;</span>,<span class="dt">lty=</span><span class="dv">1</span>)
<span class="kw">lines</span>(cent<span class="op">$</span>Age,cent<span class="op">$</span><span class="st">'0.025'</span>,<span class="dt">col=</span><span class="st">&quot;red&quot;</span>,<span class="dt">lty=</span><span class="dv">2</span>)
<span class="kw">lines</span>(cent<span class="op">$</span>Age,cent<span class="op">$</span><span class="st">'0.975'</span>,<span class="dt">col=</span><span class="st">&quot;red&quot;</span>,<span class="dt">lty=</span><span class="dv">2</span>)</code></pre></div>
<p><img src="data:image/png;base64,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" /><!-- --></p>
</div>
<div id="other-options" class="section level2">
<h2>Other options</h2>
<p><strong>localgrowth</strong> functions contain additional options not documented here. Visit the help files for the respective functions for further details.</p>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r">?localgrowth
?growthRef
?centilesLMS
?ZfromLMS
?TsimaneData</code></pre></div>
</div>
<div id="references" class="section level2">
<h2>References<a name="references"></a></h2>
<p>The following growth references/standards are included in <strong>localgrowth</strong> and should be cited appropriately if used:</p>
<div id="tsimane" class="section level3">
<h3>Tsimane</h3>
<p>Blackwell, AD, Urlacher, SS, Beheim, B, von Rueden, C, Jaeggi, A, Stieglitz, J, Tumble, BC, Gurven, MD, Kaplan, H. (2017) Growth references for Tsimane forager-horticulturalists of the Bolivian Amazon, American Journal of Physical Anthropology. 162(3) 441-461. DOI: 10.1002/ajpa.23128.</p>
</div>
<div id="shuar" class="section level3">
<h3>Shuar</h3>
<p>Urlacher, SS, Blackwell, AD, Liebert, MA, Madimenos, FC, Cepon-Robins, TJ, Gildner, TE, Snodgrass, JJ, Sugiyama, LS. (2016) Physical Growth of the Shuar: Height, Weight, and BMI Growth References for an Indigenous Amazonian Population, American Journal of Human Biology, 28(1): 16-30. DOI: 10.1002/ajhb.22747.</p>
</div>
<div id="us-center-for-disease-control-cdc" class="section level3">
<h3>US Center for Disease Control (CDC)</h3>
<p>Kuczmarski, R. J., Ogden, C. L., Guo, S. S., Grummer-Strawn, L. M., Flegal, K. M., Mei, Z., Wei, R., Curtin, L. R., Roche, A. F., Johnson, C. L. (2002). 2000 CDC Growth Charts for the United States: Methods and development. Vital Health Statistics 11,1-190. <a href="https://www.cdc.gov/growthcharts/data_tables.htm" class="uri">https://www.cdc.gov/growthcharts/data_tables.htm</a></p>
</div>
<div id="world-health-organization-who" class="section level3">
<h3>World Health Organization (WHO)</h3>
<p>World Health Organization. (2006). New child growth standards: Length/ height-for-age, weight-for-age, weight-for-length, weight-for-height and body mass index-for-age: Methods and development. Geneva: World Health Organization</p>
<p>de Onis, M., Onyango, A., Borghi, E., Siyam, A., Nishida, C., &amp; Siekman, J. (2007). Development of a WHO growth reference for school-aged children and adolescents. Bulletin of World Health Organization, 85, 660-667.</p>
<p><a href="http://www.who.int/childgrowth/en/" class="uri">http://www.who.int/childgrowth/en/</a> <a href="http://www.who.int/growthref/en/" class="uri">http://www.who.int/growthref/en/</a></p>
</div>
</div>

</body>
