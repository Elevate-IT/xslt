<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:var="http://schemas.microsoft.com/BizTalk/2003/var"
                exclude-result-prefixes="msxsl var MyScript" version="3.0"
                xmlns:ns0="www.boltrics.nl/receiveshipment:v1.00"
                xmlns:MyScript="http://schemas.microsoft.com/BizTalk/2003/MyScript">
  <xsl:output omit-xml-declaration="yes" method="xml" version="1.0" />
  <xsl:strip-space elements="*"/>
  <!-- 
       Flat-to-hierarchical grouping > https://en.wikipedia.org/wiki/XSLT/Muenchian_grouping
       K-lines  -> Document
       P-lines  -> DocumentLine        (owned by the preceding K-line)
       S-lines  -> DocumentDetailLine  (owned by the preceding P-line)
       All other lines are ignored.
       
       IMPORTANT: Line values are written as-is (no normalize-space on the value)
       because the source format is positional — character positions carry meaning.
       normalize-space is used ONLY in starts-with() checks, never on the value itself.
  -->
  <!--  Capture all Lines for global position lookup  -->
  <xsl:variable name="allLines" select="/MessageLines/Lines"/>
  <!--  Root  -->
  <xsl:template match="/">
    <ns0:Message>
      <ns0:Header>
        <ns0:MessageID>
          <xsl:value-of select="generate-id()" />
        </ns0:MessageID>
        <ns0:CreationDateTime>
          <xsl:value-of select="current-dateTime()" />
        </ns0:CreationDateTime>
        <ns0:ProcesAction>
          <xsl:text>INSERT</xsl:text>
        </ns0:ProcesAction>
        <ns0:FromTradingPartner>
          <xsl:text>...</xsl:text>
        </ns0:FromTradingPartner>
        <ns0:ToTradingPartner>
          <xsl:text>DISTRILOG</xsl:text>
        </ns0:ToTradingPartner>
        <ns0:Information>
          <xsl:text>RCV-SHIPMENT</xsl:text>
        </ns0:Information>
      </ns0:Header>
      <ns0:Documents>
        <xsl:for-each select="$allLines[starts-with(normalize-space(Line), 'K')]">
          <xsl:call-template name="Document"/>
        </xsl:for-each>
      </ns0:Documents>
    </ns0:Message>      
  </xsl:template>

  <!--  ========================================================
       K-line -> Document
       ========================================================  -->
  <xsl:template name="Document">
    <xsl:variable name="kPos" select="count(preceding-sibling::Lines) + 1"/>
    <xsl:variable name="nextKSibling" select="following-sibling::Lines[starts-with(normalize-space(Line), 'K')][1]"/>
    <xsl:variable name="nextKPos">
      <xsl:choose>
        <xsl:when test="$nextKSibling">
          <xsl:value-of select="count($nextKSibling/preceding-sibling::Lines) + 1"/>
        </xsl:when>
        <xsl:otherwise>999999</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="myPLines" select="$allLines[ starts-with(normalize-space(Line), 'P') and (count(preceding-sibling::Lines) + 1) > $kPos and (count(preceding-sibling::Lines) + 1) &lt; $nextKPos ]"/>
    <ns0:Document>
      <!-- temp -->
      <FullDocument>
        <xsl:value-of select="Line"/>
      </FullDocument>
      
      <ns0:ExternalNo>
        <xsl:value-of select="substring(Line, 17, 7)"/>
      </ns0:ExternalNo>

      <ns0:DocumentLines>
        <xsl:for-each select="$myPLines">
          <xsl:call-template name="DocumentLine">
            <xsl:with-param name="nextKPos" select="$nextKPos"/>
          </xsl:call-template>
        </xsl:for-each>
      </ns0:DocumentLines>
    </ns0:Document>
  </xsl:template>

  <!--  ========================================================
       P-line -> DocumentLine
       ========================================================  -->
  <xsl:template name="DocumentLine">
    <xsl:param name="nextKPos"/>
    <xsl:variable name="pPos" select="count(preceding-sibling::Lines) + 1"/>
    <xsl:variable name="nextPSibling" select="following-sibling::Lines[ starts-with(normalize-space(Line), 'P') and (count(preceding-sibling::Lines) + 1) &lt; $nextKPos ][1]"/>
    <xsl:variable name="nextPPos">
      <xsl:choose>
        <xsl:when test="$nextPSibling">
          <xsl:value-of select="count($nextPSibling/preceding-sibling::Lines) + 1"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$nextKPos"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="mySLines" select="$allLines[ starts-with(normalize-space(Line), 'S') and (count(preceding-sibling::Lines) + 1) > $pPos and (count(preceding-sibling::Lines) + 1) &lt; $nextPPos ]"/>
    <ns0:DocumentLine>
      <!-- temp -->
      <FullDocumentLine>
        <xsl:value-of select="Line"/>
      </FullDocumentLine>
      <ns0:DocumentDetailLines>
        <xsl:for-each select="$mySLines">
          <xsl:call-template name="DocumentDetailLine"/>
        </xsl:for-each>
      </ns0:DocumentDetailLines>
    </ns0:DocumentLine>
  </xsl:template>

  <!--  ========================================================
       S-line -> DocumentDetailLine
       ========================================================  -->
  <xsl:template name="DocumentDetailLine">
    <ns0:DocumentDetailLine>
      <!-- temp -->
      <FullDocumentDetailLine>
        <xsl:value-of select="Line"/>
      </FullDocumentDetailLine>
      
      
    </ns0:DocumentDetailLine>
  </xsl:template>
  <!--  Suppress everything else (L, T, empty lines, ...)  -->
  <xsl:template match="Lines"/>
  
  
</xsl:stylesheet>