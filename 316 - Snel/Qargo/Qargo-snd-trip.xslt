<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:ns0="www.boltrics.nl/sendtrip:v1.00">
  <xsl:output method="text" encoding="UTF-8" omit-xml-declaration="yes" />
  
  <xsl:template match="/">
    <xsl:apply-templates select="ns0:Message/ns0:Trips/ns0:Trip[1]" />
  </xsl:template>
  
  <xsl:template match="ns0:Trip">
    <xsl:text>{</xsl:text>
    
    <xsl:text>"trip_identifier":"</xsl:text>
    <xsl:call-template name="escape-json">
      <xsl:with-param name="text" select="normalize-space(ns0:No)" />
    </xsl:call-template>
    <xsl:text>",</xsl:text>
    
    <xsl:text>"status":</xsl:text>
    <xsl:text>"PLANNED"</xsl:text>
    <xsl:text>,</xsl:text>
    
    <xsl:text>"planned_stops":[</xsl:text>
    <xsl:for-each select="ns0:TripLines/ns0:TripLine">
      <xsl:variable name="stopId">
        <xsl:choose>
          <xsl:when test="normalize-space(ns0:AddressNo) != ''">
            <xsl:value-of select="normalize-space(ns0:AddressNo)" />
          </xsl:when>
          <xsl:when test="normalize-space(ns0:Documents/ns0:Document[1]/ns0:ShipToAddress/ns0:No) != ''">
            <xsl:value-of select="normalize-space(ns0:Documents/ns0:Document[1]/ns0:ShipToAddress/ns0:No)" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>UNKNOWN_STOP</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      
      <xsl:variable name="plannedDate">
        <xsl:choose>
          <xsl:when test="normalize-space(ns0:Documents/ns0:Document[1]/ns0:PlannedStartDate) != ''">
            <xsl:value-of select="normalize-space(ns0:Documents/ns0:Document[1]/ns0:PlannedStartDate)" />
          </xsl:when>
          <xsl:when test="normalize-space(../../ns0:PlannedStartDate) != ''">
            <xsl:value-of select="normalize-space(../../ns0:PlannedStartDate)" />
          </xsl:when>
          <xsl:when test="normalize-space(ns0:DeliveryDate) != ''">
            <xsl:value-of select="normalize-space(ns0:DeliveryDate)" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="normalize-space(../../ns0:Date)" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      
      <xsl:variable name="plannedTime">
        <xsl:choose>
          <xsl:when test="normalize-space(ns0:Documents/ns0:Document[1]/ns0:PlannedStartTime) != ''">
            <xsl:value-of select="normalize-space(ns0:Documents/ns0:Document[1]/ns0:PlannedStartTime)" />
          </xsl:when>
          <xsl:when test="normalize-space(../../ns0:PlannedStartTime) != ''">
            <xsl:value-of select="normalize-space(../../ns0:PlannedStartTime)" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>00:00:00</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      
      <xsl:variable name="endDate">
        <xsl:choose>
          <xsl:when test="normalize-space(ns0:Documents/ns0:Document[1]/ns0:DeliveryDate) != ''">
            <xsl:value-of select="normalize-space(ns0:Documents/ns0:Document[1]/ns0:DeliveryDate)" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$plannedDate" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      
      <xsl:variable name="endTime">
        <xsl:choose>
          <xsl:when test="normalize-space(ns0:Documents/ns0:Document[1]/ns0:AnnouncedTime) != ''">
            <xsl:value-of select="normalize-space(ns0:Documents/ns0:Document[1]/ns0:AnnouncedTime)" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$plannedTime" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      
      <xsl:text>{</xsl:text>
      <xsl:text>"sequence":</xsl:text>
      <xsl:choose>
        <xsl:when test="normalize-space(ns0:LoadOrder) != ''">
          <xsl:value-of select="normalize-space(ns0:LoadOrder)" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="position()" />
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text>,</xsl:text>
      
      <xsl:text>"id":"</xsl:text>
      <xsl:call-template name="escape-json">
        <xsl:with-param name="text" select="$stopId" />
      </xsl:call-template>
      <xsl:text>",</xsl:text>
      
      <xsl:text>"location":{"id":"</xsl:text>
      <xsl:call-template name="escape-json">
        <xsl:with-param name="text" select="$stopId" />
      </xsl:call-template>
      <xsl:text>"},</xsl:text>
      
      <xsl:text>"custom_fields":{},</xsl:text>
      <xsl:text>"start_timestamp":"</xsl:text>
      <xsl:call-template name="format-timestamp-z">
        <xsl:with-param name="date" select="$plannedDate" />
        <xsl:with-param name="time" select="$plannedTime" />
      </xsl:call-template>
      <xsl:text>",</xsl:text>
      <xsl:text>"end_timestamp":"</xsl:text>
      <xsl:call-template name="format-timestamp-z">
        <xsl:with-param name="date" select="$endDate" />
        <xsl:with-param name="time" select="$endTime" />
      </xsl:call-template>
      <xsl:text>",</xsl:text>
      <xsl:text>"fixed_timestamp_type":"ENFORCED_TIMEWINDOW",</xsl:text>
      <xsl:text>"question_answers":{}</xsl:text>
      <xsl:text>}</xsl:text>
      
      <xsl:if test="position() != last()">
        <xsl:text>,</xsl:text>
      </xsl:if>
    </xsl:for-each>
    <xsl:text>],</xsl:text>
    
    <xsl:text>"start_timestamp":"</xsl:text>
    <xsl:call-template name="format-timestamp-z">
      <xsl:with-param name="date" select="normalize-space(ns0:PlannedStartDate)" />
      <xsl:with-param name="time" select="normalize-space(ns0:PlannedStartTime)" />
    </xsl:call-template>
    <xsl:text>",</xsl:text>
    
    <xsl:text>"primary_resources":[</xsl:text>
    <xsl:if test="normalize-space(ns0:ShippingAgentCode) != ''">
      <xsl:text>{"id":"</xsl:text>
      <xsl:call-template name="escape-json">
        <xsl:with-param name="text" select="normalize-space(ns0:ShippingAgentCode)" />
      </xsl:call-template>
      <xsl:text>"}</xsl:text>
    </xsl:if>
    <xsl:text>],</xsl:text>
    
    <xsl:text>"unassigned_stops":[],</xsl:text>
    <xsl:text>"failure":{"error_type":"","error_message":""}</xsl:text>
    
    <xsl:text>}</xsl:text>
  </xsl:template>
  
  <xsl:template name="format-timestamp-z">
    <xsl:param name="date" />
    <xsl:param name="time" />
    <xsl:value-of select="normalize-space($date)" />
    <xsl:text>T</xsl:text>
    <xsl:choose>
      <xsl:when test="normalize-space($time) != ''">
        <xsl:value-of select="normalize-space($time)" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>00:00:00</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>Z</xsl:text>
  </xsl:template>
  
  <xsl:template name="escape-json">
    <xsl:param name="text" />
    <xsl:variable name="escapedBackslash">
      <xsl:call-template name="replace-string">
        <xsl:with-param name="text" select="string($text)" />
        <xsl:with-param name="search" select="'\'" />
        <xsl:with-param name="replace" select="'\\'" />
      </xsl:call-template>
    </xsl:variable>
    <xsl:call-template name="replace-string">
      <xsl:with-param name="text" select="string($escapedBackslash)" />
      <xsl:with-param name="search" select="'&quot;'" />
      <xsl:with-param name="replace" select="'\&quot;'" />
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template name="replace-string">
    <xsl:param name="text" />
    <xsl:param name="search" />
    <xsl:param name="replace" />
    <xsl:choose>
      <xsl:when test="contains($text, $search)">
        <xsl:value-of select="substring-before($text, $search)" />
        <xsl:value-of select="$replace" />
        <xsl:call-template name="replace-string">
          <xsl:with-param name="text" select="substring-after($text, $search)" />
          <xsl:with-param name="search" select="$search" />
          <xsl:with-param name="replace" select="$replace" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$text" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
