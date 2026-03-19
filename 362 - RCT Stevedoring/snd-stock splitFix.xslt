<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet 
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:ns0="http://schemas.microsoft.com/BizTalk/EDI/EDIFACT/2006"
  exclude-result-prefixes="xsl">
  
  <!-- Start at the root -->
  <xsl:template match="/">
    
    <!-- Output only the EFACT message as the new root -->
    <xsl:copy-of select="StockStatusEnvelope/Message/ns0:EFACT_D96A_INVRPT"/>
    
  </xsl:template>
  
</xsl:stylesheet>