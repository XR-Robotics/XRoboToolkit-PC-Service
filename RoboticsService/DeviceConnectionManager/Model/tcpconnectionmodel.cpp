// Implementation of TCP connection model for device communication
#include <QByteArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QDateTime>
#include "tcpconnectionmodel.h"
#include "DeviceConnectionManager_global.h"



int DevConnSDK::TCPConnectionModel::sendData(const char *data, const int size)
{
    if(m_tcpPtr == nullptr)
    {

        return -1;
    }
    m_tcpPtr->waitForBytesWritten();
    if(m_tcpPtr->write(data, size) < 0)
    {
        if(m_connectHandler != NULL)
        {
            m_connectHandler->OnUserLeave(m_uid.toLocal8Bit().data(), NULL);
        }
        else if(m_connectHandlerInQt != NULL)
        {
            emit m_connectHandlerInQt->userLeaveSignal(m_uid);
        }
        else
        {}
    }
    m_tcpPtr->waitForBytesWritten();
    return size;
}

int DevConnSDK::TCPConnectionModel::reciveData(const char *data, const int size)
{
    if(m_uid == "")
    {
        return 0;
    }

    if(m_connectHandler != NULL)
    {
        m_connectHandler->OnUserMessageReceived(m_uid.toLocal8Bit(), data, size);
    }
    else if(m_connectHandlerInQt != NULL)
    {
        QByteArray dataArray(data, size);
        emit m_connectHandlerInQt->userBinaryMsgSignal(m_uid, size, dataArray);
    }
    else
    {}

    return size;
}

void DevConnSDK::TCPConnectionModel::setConnection(QTcpSocket* tcpSocket)
{
    m_tcpPtr = tcpSocket;
    if(m_tcpPtr)
    {
        m_tcpPtr->setSocketOption(QAbstractSocket::LowDelayOption, 1);
        connect(m_tcpPtr, SIGNAL(readyRead()), this, SLOT(onReadClientMessage()), Qt::UniqueConnection);
    }
}

void DevConnSDK::TCPConnectionModel::setDisconnection()
{
    m_dataBuffer.clear();
    m_paddingLength = 0;
    m_paddingState = NoPadding;
    if(m_tcpPtr)
    {
        disconnect(m_tcpPtr, SIGNAL(readyRead()), this, SLOT(onReadClientMessage()));
    }
}

void DevConnSDK::TCPConnectionModel::onReadClientMessage()
{
    if(!m_tcpPtr)
    {
        qDebug() << "m_tcpPtr is invalid." << Qt::endl;
        return;
    }

    QByteArray buffer = m_tcpPtr->readAll();

    int size = buffer.size();
    const char* data = buffer.data();

    while(size > 0)
    {
        switch (m_paddingState) {
        case NoPadding:
        {
            if(data[0] != TCP_CLIENT_MSG_HEAD_CODE)
            {
                data++;
                size -= 1;
                break;
            }
            else{}

            if(sizeof (TCPMsgHead) > static_cast<unsigned int>(size))
            {
                qDebug() << "NoPadding data size less than head:" << QString::number(size) << Qt::endl;
                //data size less than head, append to buffer and retrun for next data reach
                m_dataBuffer.append(data, size);
                m_paddingLength = sizeof (TCPMsgHead) - size;
                m_paddingState = PaddingHead;
                return;
            }
            TcpMessage tcpMsg;
            TCPMsgHead msgHead;
            TCPMsgTail msgTail;

            memcpy(&msgHead, data, sizeof (TCPMsgHead));
            m_dataBuffer.append(data, sizeof (TCPMsgHead));
            data += sizeof (TCPMsgHead);
            size -= sizeof (TCPMsgHead);

            if(msgHead.length > static_cast<unsigned int>(size))
            {
                qDebug() << "NoPadding data size less than msg:" << QString::number(size) << Qt::endl;
                //apped data to buffer and return for next data reach
                m_dataBuffer.append(data, size);
                m_paddingLength =  msgHead.length - size;
                m_paddingState = PaddingMsg;
                return;
            }

            m_dataBuffer.append((const char *)(data), msgHead.length);
            data += msgHead.length;
            size -= msgHead.length;

            if(sizeof (TCPMsgTail)  > static_cast<unsigned int>(size))
            {
                qDebug() << "NoPadding data size less than tail:" + QString::number(size) << Qt::endl;
                //apped data to buffer and return for next data reach
                m_dataBuffer.append(data, size);
                m_paddingLength = sizeof (TCPMsgTail) - size;
                m_paddingState = PaddingTail;
                return;
            }

            memcpy(&msgTail, data, sizeof (TCPMsgTail));
            m_dataBuffer.append(data, sizeof (TCPMsgTail));
            data += sizeof (msgTail);
            size -= sizeof (msgTail);

            if (msgTail.tail != TCP_CLIENT_MSG_TAIL_CODE)
            {
                qDebug() << "NoPadding msg tail code error:" + QString::number(msgTail.tail) << Qt::endl;
                m_paddingState = NoPadding;
                m_paddingLength = 0;
                m_dataBuffer.clear();
                break;
            }
            tcpMsg.m_head = msgHead;
            tcpMsg.m_tail = msgTail;
            tcpMsg.m_msg.append(m_dataBuffer.data() + sizeof(TCPMsgHead), tcpMsg.m_head.length);
            onClientMsg(tcpMsg);
            m_dataBuffer.clear();
            m_paddingLength = 0;
            m_paddingState = NoPadding;
            break;
        }
        case PaddingHead:
        {
            if(m_paddingLength > static_cast<unsigned int>(size))
            {
                qDebug() << "PaddingHead data size less than head padding length:" << QString::number(size) << Qt::endl;
                //data size less than head padding length, append to buffer and retrun for next data reach
                m_dataBuffer.append(data, size);
                m_paddingLength = m_paddingLength - size;
                m_paddingState = PaddingHead;
                return;
            }

            TcpMessage tcpMsg;
            TCPMsgHead msgHead;
            TCPMsgTail msgTail;

            m_dataBuffer.append(data, m_paddingLength);
            memcpy(&msgHead, m_dataBuffer.data(), m_dataBuffer.size());
            data += m_paddingLength;
            size -= m_paddingLength;

            if(msgHead.length > static_cast<unsigned int>(size))
            {
                qDebug() << "PaddingHead data size less than msg:" + QString::number(size) << Qt::endl;
                //apped data to buffer and return for next data reach
                m_dataBuffer.append(data, size);
                m_paddingLength =  msgHead.length - size;
                m_paddingState = PaddingMsg;
                return;
            }

            m_dataBuffer.append((const char *)(data), msgHead.length);
            data += msgHead.length;
            size -= msgHead.length;

            if(sizeof (TCPMsgTail)  > static_cast<unsigned int>(size))
            {
                qDebug() << "PaddingHead data size less than tail:" + QString::number(size) << Qt::endl;
                //apped data to buffer and return for next data reach
                m_dataBuffer.append(data, size);
                m_paddingLength = sizeof (TCPMsgTail) - size;
                m_paddingState = PaddingTail;
                return;
            }

            memcpy(&msgTail, data, sizeof (TCPMsgTail));
            m_dataBuffer.append(data, sizeof (TCPMsgTail));
            data += sizeof (msgTail);
            size -= sizeof (msgTail);

            if (msgTail.tail != TCP_CLIENT_MSG_TAIL_CODE)
            {
                qDebug() << "PaddingHead msg tail code error:" + QString::number(msgTail.tail) << Qt::endl;
                m_paddingState = NoPadding;
                m_paddingLength = 0;
                m_dataBuffer.clear();
                break;
            }
            tcpMsg.m_head = msgHead;
            tcpMsg.m_tail = msgTail;
            tcpMsg.m_msg.append(m_dataBuffer.data() + sizeof(TCPMsgHead), tcpMsg.m_head.length);
            onClientMsg(tcpMsg);
            m_dataBuffer.clear();
            m_paddingLength = 0;
            m_paddingState = NoPadding;
            break;
        }
        case PaddingMsg:
        {
            TcpMessage tcpMsg;

            TCPMsgTail msgTail;

            if(m_paddingLength > static_cast<unsigned int>(size))
            {
                qDebug() << "PaddingMsg data size less than msg:" + QString::number(size) << Qt::endl;
                //apped data to buffer and return for next data reach
                m_dataBuffer.append(data, size);
                m_paddingLength = m_paddingLength - size;
                m_paddingState = PaddingMsg;
                return;
            }

            m_dataBuffer.append((const char *)(data), m_paddingLength);
            data += m_paddingLength;
            size -= m_paddingLength;

            if(sizeof (TCPMsgTail)  > static_cast<unsigned int>(size))
            {
                qDebug() << "PaddingMsg data size less than tail:" + QString::number(size) << Qt::endl;
                //apped data to buffer and return for next data reach
                m_dataBuffer.append(data, size);
                m_paddingLength = sizeof (TCPMsgTail) - size;
                m_paddingState = PaddingTail;
                return;
            }

            memcpy(&msgTail, data, sizeof (TCPMsgTail));
            m_dataBuffer.append(data, sizeof (TCPMsgTail));
            data += sizeof (msgTail);
            size -= sizeof (msgTail);

            if (msgTail.tail != TCP_CLIENT_MSG_TAIL_CODE)
            {
                qDebug() << "PaddingMsg msg tail code error:" + QString::number(msgTail.tail) << Qt::endl;
                m_paddingState = NoPadding;
                m_paddingLength = 0;
                m_dataBuffer.clear();
                break;
            }
            memcpy(&tcpMsg.m_head, m_dataBuffer.data(), sizeof(TCPMsgHead));
            tcpMsg.m_tail = msgTail;
            tcpMsg.m_msg.append(m_dataBuffer.data() + sizeof(TCPMsgHead), tcpMsg.m_head.length);
            onClientMsg(tcpMsg);
            m_dataBuffer.clear();
            m_paddingLength = 0;
            m_paddingState = NoPadding;
            break;
        }
        case PaddingTail:
        {
            TcpMessage tcpMsg;

            if(m_paddingLength > static_cast<unsigned int>(size))
            {
                qDebug() << "PaddingTail data size less than m_paddingLength:" + QString::number(size) << Qt::endl;
                //apped data to buffer and return for next data reach
                m_dataBuffer.append(data, size);
                m_paddingLength = m_paddingLength - size;
                m_paddingState = PaddingTail;
                return;
            }

            m_dataBuffer.append(data, sizeof (TCPMsgTail));
            data += m_paddingLength;
            size -= m_paddingLength;

            memcpy(&tcpMsg.m_head, m_dataBuffer.data(), sizeof(TCPMsgHead));
            memcpy(&tcpMsg.m_tail, m_dataBuffer.data() + sizeof(TCPMsgHead) + tcpMsg.m_head.length, sizeof(TCPMsgTail));
            tcpMsg.m_msg.append(m_dataBuffer.data() + sizeof(TCPMsgHead), tcpMsg.m_head.length);

            if (tcpMsg.m_tail.tail != TCP_CLIENT_MSG_TAIL_CODE)
            {
                qDebug() << "PaddingTail msg tail code error:" + QString::number(tcpMsg.m_tail.tail) << Qt::endl;
                m_paddingState = NoPadding;
                m_paddingLength = 0;
                m_dataBuffer.clear();
                break;
            }

            onClientMsg(tcpMsg);
            m_dataBuffer.clear();
            m_paddingLength = 0;
            m_paddingState = NoPadding;
            break;
        }
        default:
            break;
        }
    }
}

void DevConnSDK::TCPConnectionModel::onClientMsg(const TcpMessage& msg)
{
    if(dealClientPack(msg) != NORMAL)
    {
        return;
    }

    if(m_uid == "")
    {
        return;
    }

    if(m_connectHandler != NULL)
    {
        m_connectHandler->OnUserMessageReceived(m_uid.toLocal8Bit(), msg.toByteArray().data(), msg.size());
    }
    else if(m_connectHandlerInQt != NULL)
    {
        emit m_connectHandlerInQt->userBinaryMsgSignal(m_uid, msg.size(), msg.toByteArray());
    }
    else
    {}

    return;

}

int DevConnSDK::TCPConnectionModel::dealClientPack(const TcpMessage& msg)
{
    QString msgStr = QString(msg.m_msg);
    switch (msg.m_head.cmd)
    {

        case TCP_CLIENT_MSG_CONNECT:
        case TCP_CLIENT_MSG_SENSOR:
        case TCP_CLIENT_MSG_BATTERY:
        {
            if(this->m_uid == "")
            {
                QString uid = msgStr.split("|")[0];
                qDebug() << "temporary device model recive tcp connect msg, sn: " <<  uid << Qt::endl;
                emit snSettedSignal(uid, m_uuid);
                return SN_FOUND;
            }
            break;
        }
        case TCP_CLIENT_MSG_HEART_BEAT:
        {
            m_currentHeartBeatTime = QDateTime::currentSecsSinceEpoch();
            return HEART_BRAT;
        }
        default:
        {
            return NORMAL;
        }

    }
    return NORMAL;
}
