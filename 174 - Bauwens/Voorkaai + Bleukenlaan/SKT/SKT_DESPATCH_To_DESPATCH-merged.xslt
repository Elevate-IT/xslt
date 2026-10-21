<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:f="urn:elevate:skt:despatch-merged"
                exclude-result-prefixes="xs f">
  <xsl:output method="xml" indent="yes"/>
  <xsl:key name="Group-by-DelAddress" match="//DELIVERY" use="CallOffData/DeliveryAddressId" />

  <!--
    Replaces the C# script (Counter, Counter2, MinRunSeqId, MaxRunSeqId, MinRunSeqIdList).

    Per DeliveryAddressId group (first DELIVERY per address, document order):
      DeliveryId         = running number of the group                       (was GetCounter)
      DeliveryLineId     = running number of the CallOffData over ALL groups  (was GetCounter2, never reset)
      FirstLoadCarRunSeq = highest CarrierRunSeqId in the group               (was SetMaxRunSeqId/GetMaxRunSeqId)
      LoadSeq            = number of groups - number of (non-empty address) groups whose lowest
                           CarrierRunSeqId is lower than this group's lowest   (was MinRunSeqIdList.IndexOf)
  -->

  <!-- Exact port of SetMinRunSeqId: start at 0, "if (Min == 0) Min = v; if (v < Min) Min = v;" -->
  <xsl:function name="f:MinRunSeqId" as="xs:integer">
    <xsl:param name="RunSeqIds" as="xs:string*"/>
    <xsl:iterate select="$RunSeqIds[. != '']">
      <xsl:param name="Min" as="xs:integer" select="0"/>
      <xsl:on-completion select="$Min"/>
      <xsl:variable name="Value" as="xs:integer" select="xs:integer(.)"/>
      <xsl:variable name="Min1" as="xs:integer" select="if ($Min eq 0) then $Value else $Min"/>
      <xsl:next-iteration>
        <xsl:with-param name="Min" select="if ($Value lt $Min1) then $Value else $Min1"/>
      </xsl:next-iteration>
    </xsl:iterate>
  </xsl:function>

  <!-- Exact port of SetMaxRunSeqId: start at 0, "if (v == 0) Max = v; if (v > Max) Max = v;" -->
  <xsl:function name="f:MaxRunSeqId" as="xs:integer">
    <xsl:param name="RunSeqIds" as="xs:string*"/>
    <xsl:iterate select="$RunSeqIds[. != '']">
      <xsl:param name="Max" as="xs:integer" select="0"/>
      <xsl:on-completion select="$Max"/>
      <xsl:variable name="Value" as="xs:integer" select="xs:integer(.)"/>
      <xsl:variable name="Max1" as="xs:integer" select="if ($Value eq 0) then 0 else $Max"/>
      <xsl:next-iteration>
        <xsl:with-param name="Max" select="if ($Value gt $Max1) then $Value else $Max1"/>
      </xsl:next-iteration>
    </xsl:iterate>
  </xsl:function>

  <!-- CarrierRunSeqId of every DespatchData in the group of $Delivery (first CarrierRunSeqId per DespatchData,
       like the old node-set-to-string conversion when calling the script) -->
  <xsl:function name="f:GroupRunSeqIds" as="xs:string*">
    <xsl:param name="Delivery" as="element(DELIVERY)"/>
    <xsl:sequence select="for $d in key('Group-by-DelAddress', $Delivery/CallOffData/DeliveryAddressId, root($Delivery))/DespatchData
                          return string(($d/CarrierRunSeqId)[1])"/>
  </xsl:function>

  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="/">
    <xsl:apply-templates select="DESPATCH"/>
  </xsl:template>

  <xsl:template match="DESPATCH">
    <xsl:copy>
      <xsl:apply-templates select="UNH"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="UNH">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>

    <!-- First DELIVERY per DeliveryAddressId (unchanged Muenchian grouping) -->
    <xsl:variable name="Groups" select="//DELIVERY[count(. | key('Group-by-DelAddress', CallOffData/DeliveryAddressId)[1]) = 1]" />
    <xsl:variable name="GroupCount" select="count($Groups)" />

    <!-- Was the first loop + AddToMinRunSeqIdList(): lowest CarrierRunSeqId of every group with an address -->
    <xsl:variable name="MinRunSeqIdList" as="xs:integer*"
                  select="for $g in $Groups[CallOffData/DeliveryAddressId != ''] return f:MinRunSeqId(f:GroupRunSeqIds($g))" />

    <xsl:iterate select="$Groups">
      <xsl:param name="Counter2Offset" as="xs:integer" select="0" />
      <xsl:variable name="LineKey" select="CallOffData/DeliveryAddressId" />
      <xsl:variable name="Counter" select="position()" />
      <xsl:choose>
        <xsl:when test="CallOffData/DeliveryAddressId != ''">
          <xsl:variable name="RunSeqIds" select="f:GroupRunSeqIds(.)" />
          <xsl:variable name="MinRunSeqId" select="f:MinRunSeqId($RunSeqIds)" />
          <xsl:variable name="LoadSeq" select="$GroupCount - count($MinRunSeqIdList[. lt $MinRunSeqId])" />
          <xsl:variable name="FirstLoadCarRunSeq" select="f:MaxRunSeqId($RunSeqIds)" />
          <xsl:variable name="CallOffs" select="//CallOffData[DeliveryAddressId = $LineKey]" />

          <xsl:copy>
            <xsl:for-each select="$CallOffs">
              <xsl:variable name="Counter2" select="$Counter2Offset + position()" />
              <xsl:copy>
                <DeliveryId>
                  <xsl:value-of select="$Counter" />
                </DeliveryId>
                <DeliveryLineId>
                  <xsl:value-of select="$Counter2" />
                </DeliveryLineId>
                <LoadSeq>
                  <xsl:value-of select="$LoadSeq" />
                </LoadSeq>
                <FirstLoadCarRunSeq>
                  <xsl:value-of select="$FirstLoadCarRunSeq" />
                </FirstLoadCarRunSeq>
                <xsl:apply-templates select="@* | node()"/>
              </xsl:copy>
              <xsl:apply-templates select="../DespatchData">
                <xsl:with-param name="Counter" select="$Counter" />
                <xsl:with-param name="Counter2" select="$Counter2" />
                <xsl:with-param name="LoadSeq" select="$LoadSeq" />
                <xsl:with-param name="FirstLoadCarRunSeq" select="$FirstLoadCarRunSeq" />
              </xsl:apply-templates>
            </xsl:for-each>
          </xsl:copy>

          <xsl:next-iteration>
            <xsl:with-param name="Counter2Offset" select="$Counter2Offset + count($CallOffs)" />
          </xsl:next-iteration>
        </xsl:when>
        <xsl:otherwise>
          <xsl:next-iteration>
            <xsl:with-param name="Counter2Offset" select="$Counter2Offset" />
          </xsl:next-iteration>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:iterate>
  </xsl:template>

  <xsl:template match="DespatchData">
    <xsl:param name="Counter"/>
    <xsl:param name="Counter2"/>
    <xsl:param name="LoadSeq"/>
    <xsl:param name="FirstLoadCarRunSeq"/>
    <xsl:copy>
      <DeliveryId>
        <xsl:value-of select="$Counter" />
      </DeliveryId>
      <DeliveryLineId>
        <xsl:value-of select="$Counter2" />
      </DeliveryLineId>
      <LoadSeq>
        <xsl:value-of select="$LoadSeq" />
      </LoadSeq>
      <FirstLoadCarRunSeq>
        <xsl:value-of select="$FirstLoadCarRunSeq" />
      </FirstLoadCarRunSeq>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
