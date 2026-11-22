
#include "backend/diagnostics_node.hpp"
#include <chrono>
#include <cstddef>
#include <vector>
#include <unordered_map>

namespace backend {

DiagnosticsNode::DiagnosticsNode(): Node("meldog_diagnostics")
{
    jointSubscription_ =
        this->create_subscription<
            sensor_msgs::msg::JointState>(
            "/joint_states",
            10,
            [this](
                const sensor_msgs::msg::JointState::SharedPtr msg)
            {
                jointCallback(msg);
            }
        );

    RCLCPP_INFO(get_logger(), "Waiting for /joint_states...");

    for(auto& [topicName, topicData] : monitoredTopics_){
        if(topicData.subscription==nullptr)
            topicData = addGenericTopicSubscriber(topicName);
    }

    frequencyTimer_ = this->create_wall_timer(
        std::chrono::seconds(1),
        [this]() {
            std::vector<std::pair<std::string, double>> frequencies;

            for (auto& [topicName, topicData] : monitoredTopics_) {

                frequencies.push_back({topicName, topicData.messageCount});
                topicData.messageCount = 0;
                
            }
            if (topicFrequenciesCallback_) {
                topicFrequenciesCallback_(frequencies);
            }
        }
    );
}

void DiagnosticsNode::addMonitoredTopic(const std::string& topicName){
    if(monitoredTopics_.find(topicName) != monitoredTopics_.end())return;
    if (topicName.empty()) return;
    
    monitoredTopics_.emplace(topicName, addGenericTopicSubscriber(topicName));

}


void DiagnosticsNode::removeMonitoredTopic(const std::string& topicName){
    monitoredTopics_.erase(topicName);
}


DiagnosticsNode::MonitoredTopic DiagnosticsNode::addGenericTopicSubscriber(std::string topicName){

    auto topics = get_topic_names_and_types();
    auto it = topics.find(topicName);

    if (it == topics.end() || it->second.size() != 1) {
        return MonitoredTopic{};
    }

    std::string messageType = it->second[0];


    return MonitoredTopic{
        messageType,
        0, 
        
        this->create_generic_subscription(
            topicName,
            messageType,
            rclcpp::SensorDataQoS(),

            [this, topicName](std::shared_ptr<rclcpp::SerializedMessage> /*msg*/) {
                monitoredTopics_[topicName].messageCount++;
            }
            )
    };
        
}

void DiagnosticsNode::jointCallback(
    const sensor_msgs::msg::JointState::SharedPtr msg)
{
    for (size_t i = 0;
         i < msg->name.size() &&
         i < msg->position.size();
         ++i)
    {

        if(this->jointUpdateCallback_ != nullptr){
            jointUpdateCallback_(msg->name[i], msg->position[i]);
        };
    }
}

void DiagnosticsNode::setJointUpdateCallback(
    std::function<void(const std::string&, double)> callback)
{
    this->jointUpdateCallback_ = callback;
}

void DiagnosticsNode::setTopicFrequenciesCallback(std::function<void(const std::vector<std::pair<std::string, double>>&)> callback){
    topicFrequenciesCallback_ = callback;
}

}
