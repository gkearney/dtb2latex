<?xml version="1.0" encoding="utf-8"?>

<!-- 
bilder
sidebar
prodnote
annoref
table
språk
hyperlänkar
-->

<xsl:stylesheet version="2.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
				xmlns:dtb="http://www.daisy.org/z3986/2005/dtbook/"	
				exclude-result-prefixes="dtb">

	<xsl:output method="text" encoding="utf-8" indent="no"/>
	<xsl:strip-space elements="*"/>
	<xsl:preserve-space elements="code samp"/>

  <xsl:param name="fontsize">17</xsl:param>
  <xsl:param name="fontfamily">cmr</xsl:param>
  <xsl:param name="documentclass">book</xsl:param>
  <xsl:param name="defaultLanguage">english</xsl:param>
  <xsl:param name="papersize">a4paper</xsl:param>

   <xsl:template match="/">
      <xsl:apply-templates/>
   </xsl:template>

   <xsl:template match="dtb:dtbook">
	<xsl:text>% ***********************&#10;</xsl:text>
   	<xsl:text>% DMFC dtbook2latex v0.2&#10;</xsl:text>
	<xsl:text>% ***********************&#10;</xsl:text>
   	<xsl:text>\documentclass[</xsl:text>
	<xsl:value-of select="$fontsize"/><xsl:text>pt,</xsl:text>
	<xsl:value-of select="$papersize"/>
	<xsl:text>,twoside]{</xsl:text>
	<xsl:value-of select="$documentclass"/>
	<xsl:text>}&#10;</xsl:text>   
   	<xsl:text>\usepackage[pdftex]{graphicx}&#10;</xsl:text>
   	<xsl:text>\usepackage{ucs}&#10;</xsl:text>
   	<xsl:text>\usepackage[utf8x]{inputenc}&#10;</xsl:text>
   	<xsl:call-template name="findLanguage"/>
   	<xsl:text>\setlength{\parskip}{1.5ex}&#10;</xsl:text>
   	<xsl:text>\setlength{\parindent}{0ex}&#10;&#10;&#10;</xsl:text>
   	<xsl:apply-templates/>
   </xsl:template>

   <xsl:template name="iso639toBabel">
     <!-- Could probably also use lookup tables here as explained in
     http://www.ibm.com/developerworks/library/x-xsltip.html and
     http://www.ibm.com/developerworks/xml/library/x-tiplook.html -->
     <xsl:param name="iso639Code"/>
     <xsl:variable name="babelLang">
       <xsl:choose>
   	 <xsl:when test="matches($iso639Code, 'sv([_\-].+)?')">swedish</xsl:when>
   	 <xsl:when test="matches($iso639Code, 'en[_\-][Uu][Ss]')">USenglish</xsl:when>
   	 <xsl:when test="matches($iso639Code, 'en[_\-][Uu][Kk]')">UKenglish</xsl:when>
   	 <xsl:when test="matches($iso639Code, 'en([_\-].+)?')">english</xsl:when>
   	 <xsl:when test="matches($iso639Code, 'de([_\-].+)?')">ngerman</xsl:when>
	 <xsl:otherwise><xsl:value-of select="$defaultLanguage"/></xsl:otherwise>
       </xsl:choose>
     </xsl:variable>
     <xsl:value-of select="$babelLang"/>
   </xsl:template>

   <xsl:template name="findLanguage">
   	<xsl:variable name="iso639Code">
   		<xsl:choose>
	   		<xsl:when test="//dtb:meta[@name='dc:Language']">
	   			<xsl:value-of select="//dtb:meta[@name='dc:Language']/@content"/>
	   		</xsl:when>
	   		<xsl:when test="//dtb:meta[@name='dc:language']">
	   			<xsl:value-of select="//dtb:meta[@name='dc:language']/@content"/>
	   		</xsl:when>
	   		<xsl:when test="/dtb:dtbook/@xml:lang">
	   			<xsl:value-of select="/dtb:dtbook/@xml:lang"/>
	   		</xsl:when>   			
   		</xsl:choose>
   	</xsl:variable>
   	<xsl:text>\usepackage[</xsl:text>
   	<xsl:call-template name="iso639toBabel">
 	  <xsl:with-param name="iso639Code">
	    <xsl:value-of select="$iso639Code"/>
	  </xsl:with-param>
	</xsl:call-template>
   	<xsl:text>]{babel}&#10;</xsl:text>
   </xsl:template>

   <xsl:template match="dtb:head">
   	<xsl:apply-templates/>
   </xsl:template>

   <xsl:template match="dtb:meta">
   	<xsl:apply-templates/>
   </xsl:template>

   <xsl:template match="dtb:book">
	<xsl:text>\begin{document}&#10;</xsl:text>
        <xsl:text>\fontfamily{</xsl:text><xsl:value-of select="$fontfamily"/><xsl:text>}\selectfont&#10;</xsl:text>
	<xsl:apply-templates/>
	<xsl:text>\end{document}&#10;</xsl:text>
   </xsl:template>

   <xsl:template match="dtb:frontmatter">
   	<xsl:text>\frontmatter&#10;</xsl:text>
   	<xsl:apply-templates select="//dtb:meta" mode="titlePage"/>
	<xsl:text>\maketitle&#10;</xsl:text>
	<xsl:if test="dtb:level1/dtb:list[descendant::dtb:lic]">
		<xsl:text>\tableofcontents&#10;</xsl:text>
	</xsl:if>
	<xsl:apply-templates/>
   </xsl:template>

   <xsl:template match="dtb:frontmatter/dtb:level1/dtb:list[descendant::dtb:lic]" priority="1">
   	<xsl:message>skip!</xsl:message>
   </xsl:template>

	<xsl:template match="dtb:meta[@name='dc:title' or @name='dc:Title']" mode="titlePage">
		<xsl:text>\title{</xsl:text>
		<xsl:value-of select="@content"/>
		<xsl:text>}&#10;</xsl:text>
	</xsl:template>

	<xsl:template match="dtb:meta[@name='dc:creator' or @name='dc:Creator']" mode="titlePage">
		<xsl:text>\author{</xsl:text>
		<xsl:value-of select="@content"/>
		<xsl:text>}&#10;</xsl:text>
	</xsl:template>

	<xsl:template match="dtb:meta[@name='dc:date' or @name='dc:Date']" mode="titlePage">
		<xsl:text>\date{</xsl:text>
		<xsl:value-of select="@content"/>
		<xsl:text>}&#10;</xsl:text>
	</xsl:template>

   <xsl:template match="dtb:level1">
   	<xsl:apply-templates/>
   </xsl:template>

   <xsl:template match="dtb:level2">
   	<xsl:apply-templates/>
   </xsl:template>

   <xsl:template match="dtb:level3">
   	<xsl:apply-templates/>
   </xsl:template>

   <xsl:template match="dtb:level4">
   	<xsl:apply-templates/>
   </xsl:template>

   <xsl:template match="dtb:level5">
   	<xsl:apply-templates/>
   </xsl:template>

   <xsl:template match="dtb:level6">
   	<xsl:apply-templates/>
   </xsl:template>

   <xsl:template match="dtb:level">
   	<xsl:apply-templates/>
   </xsl:template>

   <xsl:template match="dtb:doctitle">
   </xsl:template>
   
   <xsl:template match="dtb:docauthor">
   </xsl:template>
   
   <xsl:template match="dtb:covertitle">
   </xsl:template>

   <xsl:template match="dtb:p">   
	<xsl:apply-templates/>
	<xsl:text>&#10;&#10;</xsl:text>
   </xsl:template>

   <xsl:template match="dtb:pagenum">
     <xsl:text>\marginpar{</xsl:text>
	<xsl:apply-templates/>
     <xsl:text>}&#10;</xsl:text>
   </xsl:template>

   <xsl:template match="dtb:address">
  	<xsl:apply-templates/>
   </xsl:template>

   <xsl:template match="dtb:h1">
   	<xsl:text>\chapter{</xsl:text>
   	<xsl:apply-templates/>
   	<xsl:text>}&#10;</xsl:text>
   </xsl:template>

   <xsl:template match="dtb:h2">
   	<xsl:text>\section{</xsl:text>
   	<xsl:apply-templates/>
   	<xsl:text>}&#10;</xsl:text>
   </xsl:template>

   <xsl:template match="dtb:h3">
   	<xsl:text>\subsection{</xsl:text>
   	<xsl:apply-templates/>
   	<xsl:text>}&#10;</xsl:text>   
   </xsl:template>

   <xsl:template match="dtb:h4">
   	<xsl:text>\subsubsection{</xsl:text>
   	<xsl:apply-templates/>
   	<xsl:text>}&#10;</xsl:text>   
   </xsl:template>

   <xsl:template match="dtb:h5">
   	<xsl:text>\paragraph{</xsl:text>
   	<xsl:apply-templates/>
   	<xsl:text>}&#10;</xsl:text>   
   </xsl:template>

   <xsl:template match="dtb:h6">
   	<xsl:text>\subparagraph{</xsl:text>
   	<xsl:apply-templates/>
   	<xsl:text>}&#10;</xsl:text>   
   </xsl:template>

  <xsl:template match="dtb:bridgehead">
  	<xsl:apply-templates/>
   </xsl:template>

   <xsl:template match="dtb:list[not(@type)]">
   	<xsl:apply-templates/>
   </xsl:template>

   <xsl:template match="dtb:lic">
   	<xsl:apply-templates/>
   	<xsl:if test="following-sibling::dtb:lic or normalize-space(following-sibling::text())!=''">
	   	<xsl:text>\dotfill </xsl:text>
   	</xsl:if>
   </xsl:template>

   <xsl:template match="dtb:br">
   	<xsl:text>\\*&#10;</xsl:text>
   </xsl:template>

   <xsl:template match="dtb:bodymatter">
   <xsl:text>\mainmatter&#10;</xsl:text>
	<xsl:apply-templates/>
   </xsl:template>

   <xsl:template match="dtb:noteref">
   	<xsl:text>\footnote{</xsl:text>
   	<xsl:variable name="refText">
   		<xsl:value-of select="normalize-space(//*[@id=current()/@idref])"/>
   	</xsl:variable>
	<xsl:call-template name="replace">
		<xsl:with-param name="text">
			<xsl:value-of select="$refText"/>
		</xsl:with-param>
	</xsl:call-template>
   	<xsl:text>}</xsl:text>
   </xsl:template>

   <xsl:template match="dtb:img">
   	<!--<xsl:apply-templates/>-->
   	<!--<xsl:text>\begin{picture}(5,2)&#10;</xsl:text>
   	<xsl:text>\setlength{\fboxsep}{0.25cm}&#10;</xsl:text>
   	<xsl:text>\put(0,0){\framebox(5,2){}}&#10;</xsl:text>
   	<xsl:text>\put(1,1){\fbox{Missing image}}&#10;</xsl:text>
   	<xsl:text>\end{picture}&#10;</xsl:text>
   	-->
   	<xsl:text>\includegraphics{</xsl:text>
   	<xsl:value-of select="@src"/>
   	<xsl:text>}&#10;&#10;</xsl:text>
   </xsl:template>

   <xsl:template match="dtb:caption">
   	<xsl:apply-templates/>
   </xsl:template>

   <xsl:template match="dtb:imggroup/dtb:caption">
   	<!--<xsl:apply-templates/>-->
   </xsl:template>
   
   <xsl:template match="dtb:table/dtb:caption">
   	<!--<xsl:apply-templates/>-->
   </xsl:template>
   
   <xsl:template match="dtb:caption" mode="captionOnly">
   	<!--<xsl:text>\caption{</xsl:text>-->
   	<xsl:apply-templates mode="textOnly"/>
   	<xsl:text>&#10;</xsl:text>
   	<!--<xsl:text>}&#10;</xsl:text>-->
   </xsl:template>

   <xsl:template match="dtb:div">
   	<xsl:apply-templates/>
   </xsl:template>

   <xsl:template match="dtb:imggroup">
   	<!--
   	<xsl:text>\fbox{\fbox{\parbox{10cm}{</xsl:text>
   	<xsl:apply-templates/>
   	<xsl:text>}}}</xsl:text>
   	-->
   	<xsl:text>\begin{figure}[h]&#10;</xsl:text>
   	<xsl:apply-templates/>
   	<xsl:apply-templates select="dtb:caption" mode="captionOnly"/>
   	<xsl:text>\end{figure}&#10;</xsl:text>   	
   </xsl:template>

   <xsl:template match="dtb:annotation">
   	<xsl:apply-templates/>
   </xsl:template>

   <xsl:template match="dtb:author">	
   	<xsl:apply-templates/>
   </xsl:template>

   <xsl:template match="dtb:blockquote">
   	<xsl:text>\begin{quote}&#10;</xsl:text>
   	<xsl:apply-templates/>
   	<xsl:text>\end{quote}&#10;</xsl:text>
   </xsl:template>

  <xsl:template match="dtb:byline">
  	<xsl:apply-templates/>
   </xsl:template>

  <xsl:template match="dtb:dateline">
  	<xsl:apply-templates/>
   </xsl:template>

  <xsl:template match="dtb:epigraph">
  	<xsl:apply-templates/>
   </xsl:template>

   <xsl:template match="dtb:note">
   	<!--<xsl:apply-templates/>-->
   </xsl:template>

   <xsl:template match="dtb:sidebar">
   	<xsl:text>\fbox{\parbox{10cm}{</xsl:text>
   	<xsl:apply-templates/>
   	<xsl:text>}}&#10;&#10;</xsl:text>
   </xsl:template>

   <xsl:template match="dtb:hd">
     <xsl:variable name="level">
       <xsl:value-of select="count(ancestor::dtb:level)"/>
     </xsl:variable>
     <xsl:choose>
       <xsl:when test="$level=1"><xsl:text>\chapter{</xsl:text></xsl:when>
       <xsl:when test="$level=2"><xsl:text>\section{</xsl:text></xsl:when>
       <xsl:when test="$level=3"><xsl:text>\subsection{</xsl:text></xsl:when>
       <xsl:when test="$level=4"><xsl:text>\subsubsection{</xsl:text></xsl:when>
       <xsl:when test="$level=5"><xsl:text>\paragraph{</xsl:text></xsl:when>
       <xsl:when test="$level>5"><xsl:text>\subparagraph{</xsl:text></xsl:when>
     </xsl:choose>
     <xsl:apply-templates/>
     <xsl:text>}&#10;</xsl:text>
   </xsl:template>

   <xsl:template match="dtb:list/dtb:hd">
   	<xsl:text>\item \textbf{</xsl:text>
	<xsl:apply-templates/>
	<xsl:text>}&#10;</xsl:text>
   </xsl:template>

   <xsl:template match="dtb:list[@type='ol']">
   	<xsl:text>\begin{enumerate}&#10;</xsl:text>
	<xsl:apply-templates/>
	<xsl:text>\end{enumerate}&#10;</xsl:text>
   </xsl:template>
   
   <xsl:template match="dtb:list[@type='ul']">
   	<xsl:text>\begin{itemize}&#10;</xsl:text>
	<xsl:apply-templates/>
	<xsl:text>\end{itemize}&#10;</xsl:text>
   </xsl:template>

   <xsl:template match="dtb:list[@type='pl']">
   	<xsl:text>\begin{trivlist}&#10;</xsl:text>
	<xsl:apply-templates/>
	<xsl:text>\end{trivlist}&#10;</xsl:text>
   </xsl:template>

   <xsl:template match="dtb:li">
   	<xsl:text>\item </xsl:text>
	<xsl:apply-templates/>
	<xsl:text>&#10;</xsl:text>
   </xsl:template>

   <xsl:template match="dtb:dl">
   	<xsl:text>\begin{description}</xsl:text>
   	<xsl:apply-templates/>
   	<xsl:text>\end{description}</xsl:text>
   </xsl:template>

  <xsl:template match="dtb:dt">
  	<xsl:text>\item[</xsl:text>
  	<xsl:apply-templates/>
  	<xsl:text>] </xsl:text>
   </xsl:template>

  <xsl:template match="dtb:dd">
  	<xsl:apply-templates/>
  	<xsl:text>&#10;</xsl:text>
   </xsl:template>

   <xsl:template match="dtb:table">
   	<xsl:text>\begin{table}[h]</xsl:text>
   	<xsl:apply-templates select="dtb:caption" mode="captionOnly"/>
   	<xsl:text>\begin{tabular}{</xsl:text>
   	<xsl:variable name="numcols">
   		<xsl:value-of select="count(descendant::dtb:tr[1]/*[self::dtb:td or self::dtb:th])"/>
   	</xsl:variable>
   	<xsl:for-each select="descendant::dtb:tr[1]/*[self::dtb:td or self::dtb:th]">
   		<xsl:text>|p{</xsl:text>
   		<xsl:value-of select="10 div $numcols"/>
   		<xsl:text>cm}</xsl:text>
   	</xsl:for-each>
   	<xsl:text>|} \hline&#10;</xsl:text>
   	<xsl:apply-templates/>
   	<xsl:text>\end{tabular}&#10;</xsl:text>
   	<xsl:text>\end{table}&#10;</xsl:text>
   </xsl:template>

   <xsl:template match="dtb:tbody">
   	<xsl:apply-templates/>
   </xsl:template>

   <xsl:template match="dtb:thead">
   	<xsl:apply-templates/>   
   </xsl:template>

   <xsl:template match="dtb:tfoot">
   	<xsl:apply-templates/>
   </xsl:template>

   <xsl:template match="dtb:tr">
   	<xsl:apply-templates/>
   	<xsl:text>\\ \hline&#10;</xsl:text>
   </xsl:template>

   <xsl:template match="dtb:th">
   	<xsl:if test="preceding-sibling::dtb:th">
   		<xsl:text> &amp; </xsl:text>
   	</xsl:if>
   	<xsl:apply-templates/>
   </xsl:template>

   <xsl:template match="dtb:td">
   	<xsl:if test="preceding-sibling::dtb:td">
   		<xsl:text> &amp; </xsl:text>
   	</xsl:if>
   	<xsl:apply-templates/>
   </xsl:template>

   <xsl:template match="dtb:colgroup">
   	<xsl:apply-templates/>
   </xsl:template>

   <xsl:template match="dtb:col">
   	<xsl:apply-templates/>
   </xsl:template>

   <xsl:template match="dtb:poem">
   	<xsl:text>\begin{verse}&#10;</xsl:text>
   	<xsl:apply-templates/>
   	<xsl:text>\end{verse}&#10;</xsl:text>
   </xsl:template>

   <xsl:template match="dtb:poem/dtb:title">
   	<xsl:apply-templates/>
   </xsl:template>

   <xsl:template match="dtb:cite/dtb:title">
   	<xsl:apply-templates/>
   </xsl:template>

   <xsl:template match="dtb:cite">
   	<xsl:apply-templates/>
   </xsl:template>

   <xsl:template match="dtb:code">
   	<xsl:text>\texttt{</xsl:text>
   	<xsl:apply-templates/>
   	<xsl:text>}</xsl:text>
   </xsl:template>

   <xsl:template match="dtb:kbd">
   	<xsl:text>\texttt{</xsl:text>
   	<xsl:apply-templates/>
   	<xsl:text>}</xsl:text>
   </xsl:template>

   <xsl:template match="dtb:q">
   	<xsl:text>\textsl{</xsl:text>
   	<xsl:apply-templates/>
   	<xsl:text>}</xsl:text>
   </xsl:template>

   <xsl:template match="dtb:samp">
   	<xsl:text>\texttt{</xsl:text>
   	<xsl:apply-templates/>
   	<xsl:text>}</xsl:text>
   </xsl:template>

   <xsl:template match="dtb:linegroup">   	
   	<xsl:apply-templates/>
	<xsl:text>&#10;</xsl:text>
   </xsl:template>

   <xsl:template match="dtb:line">
   	<xsl:apply-templates/>
	<xsl:text>\\&#10;</xsl:text>
   </xsl:template>

   <xsl:template match="dtb:linenum">
   	<xsl:apply-templates/>
   </xsl:template>

   <xsl:template match="dtb:prodnote">
   	<xsl:text>\marginpar{\framebox[5mm]{!}}&#10;</xsl:text>
   </xsl:template>

   <xsl:template match="dtb:rearmatter">
   	<xsl:text>\backmatter&#10;</xsl:text>
	<xsl:apply-templates/>
   </xsl:template>

   <xsl:template match="dtb:a">
   	<xsl:apply-templates/>
   </xsl:template>

	<xsl:template match="dtb:em">
		<xsl:text>\emph{</xsl:text>
		<xsl:apply-templates/>
		<xsl:text>}</xsl:text>		
   	</xsl:template>

   <xsl:template match="dtb:strong">
   	<xsl:text>\textbf{</xsl:text>
	<xsl:apply-templates/>
	<xsl:text>}</xsl:text>
   </xsl:template>

   <xsl:template match="dtb:abbr">
   	<xsl:apply-templates/>
   </xsl:template>

  <xsl:template match="dtb:acronym">
   	<xsl:apply-templates/>
   </xsl:template>

  <xsl:template match="dtb:bdo">
   	<xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="dtb:dfn">
   	<xsl:apply-templates/>
   </xsl:template>

  <xsl:template match="dtb:sent">
   	<xsl:apply-templates/>
   </xsl:template>

  <xsl:template match="dtb:w">
   	<xsl:apply-templates/>
   </xsl:template>

   <xsl:template match="dtb:sup">
 	<xsl:text>$^{</xsl:text>
   	<xsl:apply-templates/>
   	<xsl:text>}$</xsl:text>
   </xsl:template>

   <xsl:template match="dtb:sub">
   	<xsl:text>$_{</xsl:text>
   	<xsl:apply-templates/>
   	<xsl:text>}$</xsl:text>
   </xsl:template>

   <xsl:template match="dtb:a[@href]">
   	<xsl:apply-templates/>
   </xsl:template>

  <xsl:template match="dtb:annoref">
   	<xsl:apply-templates/>
   </xsl:template>

	<xsl:template match="text()">
		<xsl:value-of select="replace(replace(current(), '\s+', ' '), '(\$|&amp;|%|#|_|\{|\}|\\)', '\\$1')"/>
		<!--<xsl:value-of select="."/>-->
   	</xsl:template>
   	
   	<xsl:template match="text()" mode="textOnly">
		<xsl:value-of select="replace(replace(current(), '\s+', ' '), '(\$|&amp;|%|#|_|\{|\}|\\)', '\\$1')"/>
		<!--<xsl:value-of select="."/>-->
   	</xsl:template>
   	
   	<xsl:template name="replace">
   		<xsl:param name="text"/>
   		<xsl:value-of select="replace(replace($text, '\s+', ' '), '(\$|&amp;|%|#|_|\{|\}|\\)', '\\$1')"/>
   	</xsl:template>
   	
   <xsl:template match="dtb:*">
     <xsl:message>
  *****<xsl:value-of select="name(..)"/>/{<xsl:value-of select="namespace-uri()"/>}<xsl:value-of select="name()"/>******
   </xsl:message>
   </xsl:template>

</xsl:stylesheet>
