//Implementation of PXR Enterprise Assistant Robot SDK client

#include <memory>
#include <sstream>
#include <fstream>
#include <grpcpp/grpcpp.h>
#include <PXREAService.pb.h>
#include <PXREAService.grpc.pb.h>
#include "PXREARobotSDK.h"
#include "inipp.h"
#include "nlohmann/json.hpp"
#include <string>
#include <unordered_map>
#ifdef _WIN32
#include <Windows.h>
static void OutputDebug(const char* str)
{
    OutputDebugStringA(str);
}

static unsigned GetCurrentPid()
{
    return GetCurrentProcessId();
}

#endif

#if defined(LINUX_x86) || defined(LINUX_aarch64)
#include <chrono>
#include <iomanip>
#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <thread>


#define strcpy_s(dest, destsz, src) strncpy(dest, src, destsz)

static void OutputDebug(const char* str)
{
    const auto now = std::chrono::system_clock::now().time_since_epoch();
    const auto seconds = std::chrono::duration_cast<std::chrono::seconds>(now);
    const auto nanoseconds = std::chrono::duration_cast<std::chrono::nanoseconds>(now - seconds);

    std::cout << "[INFO] [" << seconds.count() << "."
              << std::setw(9) << std::setfill('0') << nanoseconds.count()
              << std::setfill(' ') << "] [PXREARobotSDK]: " << str << std::endl;
}

static unsigned GetCurrentPid()
{
    return getpid();
}
#endif
struct StreamHelper
{
    std::ostringstream stream;
    template< typename T >
    StreamHelper& operator<<( const T& value )
    {
        stream << value; return *this;
    }
    std::string str() const
    {
        return stream.str();
    }
    operator std::string() const
    {
        return stream.str();
    }
};
unsigned g_mask = PXREAFullMask;
void* g_context;
pfPXREAClientCallback gOnPXREAClientCallback;
//client sdk implement

using PXREAService::EAService;

class PXREAClient
{
public:
    PXREAClient(std::shared_ptr<grpc::Channel> channel):m_stub(EAService::NewStub(channel)){}

    int DeviceControlJson(const char *devID,const char *parameterJson)
    {
        auto paraJson = nlohmann::json::parse(parameterJson);
        PXREAService::DeviceControlParameterJson dcpj;
        dcpj.set_devid(devID);
        dcpj.set_parameter(parameterJson);
        grpc::ClientContext ctx;
        google::protobuf::Empty ept;
        grpc::Status status = m_stub->DeviceControlJson(&ctx,dcpj,&ept);
        if(status.ok() == false)
        {
            OutputDebug("set function enable failed");
        }
        return status.ok() ? 0 : -1;
    }
    int SendBytesToDevice(const char *devID,const char *data,unsigned len)
    {
        PXREAService::DeviceBytesInfo info;
        info.set_devid(devID);
        info.set_content(std::string{data,len});
        grpc::ClientContext ctx;
        google::protobuf::Empty ept;
        grpc::Status status = m_stub->SendBytesToDevice(&ctx,info,&ept);
        if(status.ok() == false)
        {
            OutputDebug("send bytes to device failed ");
        }
        return status.ok() ? 0 : -1;
    }

    void WatchServerFeedback(){
        OutputDebug("client start server stream ");
       m_feedbackThread =  std::thread([this]{
            PXREAService::VRPid vrPid;
            vrPid.set_pid(GetCurrentPid());
            grpc::ClientContext feedbackCtx;
            std::unique_lock<std::mutex> lk(m_mtx);
            OutputDebug("watch server feedback thread start");
            std::unique_ptr<grpc::ClientReader<PXREAService::ServerFeedback>> reader(m_stub->WatchServerFeedback(&feedbackCtx,vrPid));
            m_feedbackCtx = &feedbackCtx;
            lk.unlock();
            PXREAService::ServerFeedback feedBack;
            while(reader->Read(&feedBack))
            {
                if(feedBack.name() == "deviceFind")
                {
                    if(g_mask & PXREADeviceFind)
                    {
                        gOnPXREAClientCallback(g_context,PXREADeviceFind,0,const_cast<char*>(feedBack.devid().c_str()));
                        OutputDebug((StreamHelper()<<"device find "<<feedBack.devid()).str().c_str());
                    }
                    else
                    {
                        OutputDebug("ignore device find ");
                    }
                }
                else if(feedBack.name() == "deviceMissing")
                {
                    if(g_mask & PXREADeviceMissing)
                    {
                        gOnPXREAClientCallback(g_context,PXREADeviceMissing,0,const_cast<char*>(feedBack.devid().c_str()));
                        OutputDebug((StreamHelper()<<"device missing "<<feedBack.devid()).str().c_str());
                    }
                    else
                    {
                        OutputDebug("ignore device missing ");
                    }
                }
                else if(feedBack.name() == "deviceConnect")
                {
                    if(g_mask & PXREADeviceConnect)
                    {
                        gOnPXREAClientCallback(g_context,PXREADeviceConnect,feedBack.devstatus().status(),const_cast<char*>(feedBack.devstatus().devid().c_str()));
                        OutputDebug((StreamHelper()<<"device connect "<<feedBack.devstatus().devid()<<feedBack.devstatus().status()).str().c_str());
                    }
                    else
                    {
                        OutputDebug("ignore device connect ");
                    }
                }
                else if(feedBack.name() == "deviceStateJson")
                {
                    if(g_mask & PXREADeviceStateJson)
                    {
                        PXREADevStateJson dsj{};
                        strcpy_s(dsj.devID,32,feedBack.devicestatejson().devid().c_str());
                        strcpy_s(dsj.stateJson,16352,feedBack.devicestatejson().statejson().c_str());
                        gOnPXREAClientCallback(g_context,PXREADeviceStateJson,0,&dsj);
                        //OutputDebug((StreamHelper()<<"device "<<dsj.devID<<"device state json "<<dsj.stateJson).str().c_str());
                    }
                }
                else if(feedBack.name() == "deviceCustomMessage")
                {
                    if(g_mask & PXREADeviceCustomMessage)
                    {
                        PXREADevCustomMessage dcm{};
                        strcpy_s(dcm.devID,32,feedBack.devblob().devid().c_str());
                        dcm.dataSize = feedBack.devblob().content().size();
                        dcm.dataPtr = feedBack.devblob().content().data();
                        gOnPXREAClientCallback(g_context,PXREADeviceCustomMessage,0,&dcm);
                        OutputDebug((StreamHelper()<<"device "<<dcm.devID).str().c_str());
                    }
                }

            }
            grpc::Status status = reader->Finish();
            if(status.ok() == false)
            {
                OutputDebug(status.error_message().c_str());
            }
            lk.lock();
            m_feedbackCtx = nullptr;
            lk.unlock();
        });

    }
    void StopWatchFeedback()
    {
        std::unique_lock<std::mutex> lk(m_mtx);
        if(m_feedbackCtx)
        {
            m_feedbackCtx->TryCancel();
            PXREAService::VRPid vrPid;
            vrPid.set_pid(GetCurrentPid());
            grpc::ClientContext feedbackCtx;
            google::protobuf::Empty ept;
            m_stub->CancelServerFeedback(&feedbackCtx,vrPid,&ept);
        }
        lk.unlock();
    }
    void WaitWatchFeedbackExit()
    {
        OutputDebug("client cancel server stream start");
        if(m_feedbackThread.joinable())
        {
//            m_feedbackCtx.TryCancel();
            m_feedbackThread.join();
        }
        OutputDebug("client cancel server stream end");
    }
    bool SendBeat() {
        google::protobuf::Empty eptIn;
        google::protobuf::Empty eptOut;
        grpc::ClientContext context;
        context.set_wait_for_ready(true);
        context.set_deadline(std::chrono::system_clock::now()+std::chrono::milliseconds(500));

        // The actual RPC.
        grpc::Status status = m_stub->SendBeat(&context, eptIn, &eptOut);
        return status.ok();
    }
    void StartServiceCheck()
    {
        m_bChecking = true;
        m_checkThread = std::thread([this]{
            bool connect = false;
            while(m_bChecking)
            {
                if(SendBeat())
                {
                    std::this_thread::sleep_for(std::chrono::milliseconds(500));
                    if(connect == false)
                    {
                        WatchServerFeedback();
                        if(g_mask & PXREAServerConnect)
                        {
                            gOnPXREAClientCallback(g_context,PXREAServerConnect,0,nullptr);
                            OutputDebug("server connect");
                        }
                        else
                        {
                            OutputDebug("ignore server connect");
                        }
                        connect = true;
                    }
                }
                else
                {
                    if(connect)
                    {
                        WaitWatchFeedbackExit();
                        if(g_mask & PXREAServerDisconnect)
                        {
                            gOnPXREAClientCallback(g_context,PXREAServerDisconnect,0,nullptr);
                            OutputDebug("server disconnect");
                        }
                        else
                        {
                            OutputDebug("ignore server disconnect");
                        }
                        connect = false;
                    }
                }
            }
        });
    }
    void StopServiceCheck(){
        m_bChecking = false;
    }
    void WaitServiceCheckExit(){
        m_checkThread.join();
    }
private:
    grpc::ClientContext* m_feedbackCtx{nullptr};
    std::thread m_feedbackThread;
    std::unique_ptr<EAService::Stub> m_stub;
    bool m_bChecking;
    std::thread m_checkThread;
    std::mutex m_mtx;
};

std::shared_ptr<PXREAClient> g_pClient;
template <class T>
T PXREAGetSDKClientConfig(const char* section, const char* key, const T& defaultValue)
{
    inipp::Ini<char> ini;
    std::ifstream ifs("PXREASetting.ini");
    ini.parse(ifs);
    T val = defaultValue;
    inipp::get_value(ini.sections[section], key, val);
    return val;
}
int PXREAInit(void* context,pfPXREAClientCallback cliCallback,unsigned mask)
{
    OutputDebug("initialize sdk,connect to server");
    std::string addr = PXREAGetSDKClientConfig("Client","connectAddr",std::string("127.0.0.1"));
    std::string port = PXREAGetSDKClientConfig("Client","connectPort",std::string("60061"));
    std::string connectStr= addr+":"+port;
    gOnPXREAClientCallback = cliCallback;
    g_mask = mask;
    g_context = context;
    grpc::ChannelArguments channelArgs;
    g_pClient = std::make_shared<PXREAClient>(grpc::CreateCustomChannel(connectStr.c_str(), grpc::InsecureChannelCredentials(),channelArgs));
    g_pClient->StartServiceCheck();
    return 0;
}

int PXREADeinit()
{
    g_pClient->StopServiceCheck();
    g_pClient->WaitServiceCheckExit();
    g_pClient->StopWatchFeedback();
    g_pClient->WaitWatchFeedbackExit();
    g_pClient.reset();
    OutputDebug("uninitialize sdk");
    return 0;
}


int PXREADeviceControlJson(const char *devID,const char *parameterJson)
{
    return g_pClient->DeviceControlJson(devID,parameterJson);
}
int PXREASendBytesToDevice(const char *devID,const char *data,unsigned len)
{
    return g_pClient->SendBytesToDevice(devID,data,len);
}
