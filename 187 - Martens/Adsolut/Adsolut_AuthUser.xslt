<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="">
  
  <xsl:output method="xml" version="1.0" encoding="utf-8"/>

  <!-- Root template -->
  <xsl:template match="/">
    <soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                     xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                     xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">
      <soap12:Body>
        <AuthenticateUser xmlns="http://websrv.adsolut.be/webservices">
          <userName>Web3</userName>
          <passWord>!Turnhout2300</passWord>
          <database>100003</database>
        </AuthenticateUser>
      </soap12:Body>
    </soap12:Envelope>
  </xsl:template>
  
</xsl:stylesheet>
