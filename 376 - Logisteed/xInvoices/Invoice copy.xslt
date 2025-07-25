<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">
  <xsl:output method="xml" indent="yes"/>
  
  <!-- Match the root -->
  <xsl:template match="/MessageLines">
    <!-- Extract the header from the first line -->
    <Header>
      <xsl:value-of select="normalize-space(substring-before(Lines[1]/Line, ' - '))"/>
    </Header>
    <Lines>
      <!-- Loop through each Lines/Line -->
      <xsl:for-each select="Lines/Line">
        <Line>
          <xsl:value-of select="normalize-space(substring-after(., ' - '))"/>
        </Line>
      </xsl:for-each>
    </Lines>
  </xsl:template>
  
</xsl:stylesheet>
